import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'cocktail_db_service.dart';

// ─── Result models ─────────────────────────────────────────────────────────

enum GenieMode { bottles, preparedDrink, emptyGlass, unclear }

class VisionAnalysisResult {
  final List<String> ingredients;
  final List<String> bottles;
  final List<Map<String, dynamic>> drinks;
  final List<double> confidence;
  final String genieDescription;
  final GenieMode mode;
  final String? detectedGlassType;
  final String? error;
  final int imageCount;

  VisionAnalysisResult({
    required this.ingredients,
    required this.bottles,
    required this.drinks,
    required this.confidence,
    required this.genieDescription,
    required this.mode,
    required this.imageCount,
    this.detectedGlassType,
    this.error,
  });

  bool get hasError => error != null;
  bool get isEmpty =>
      ingredients.isEmpty && bottles.isEmpty && drinks.isEmpty;

  factory VisionAnalysisResult.withError(String error) =>
      VisionAnalysisResult(
        ingredients: [],
        bottles: [],
        drinks: [],
        confidence: [],
        genieDescription: '',
        mode: GenieMode.unclear,
        imageCount: 0,
        error: error,
      );
}

// ─── Service ───────────────────────────────────────────────────────────────

class OpenAiVisionService {
  static const _apiKey = String.fromEnvironment('ANTHROPIC_API_KEY');
  static const _endpoint = 'https://api.anthropic.com/v1/messages';
  static const _model = 'claude-opus-4-5';
  static const _maxImages = 4;

  final _db = CocktailDbService();

  static const _systemPrompt = '''
You are the Cocktail Genie — a mystical, witty expert in all things cocktail-related.
Analyze ALL provided images carefully and respond ONLY with valid JSON.

First determine which MODE applies:
- MODE "bottles": You can see liquor bottles, ingredients, mixers (even partial/blurry labels)
- MODE "preparedDrink": You see an already-made cocktail or drink in a glass
- MODE "emptyGlass": You see empty glass(es), empty bottles, or a bar setup with no drinks
- MODE "unclear": Image is too blurry, dark, or contains no drink-related items

Then respond with this exact JSON structure:
{
  "mode": "bottles|preparedDrink|emptyGlass|unclear",
  "bottles": ["Brand Name 1", "Brand Name 2"],
  "ingredients": ["ingredient1", "ingredient2"],
  "drinks": ["Name 1", "Name 2", "Name 3", "Name 4", "Name 5", "Name 6", "Name 7", "Name 8", "Name 9", "Name 10"],
  "confidence": [0.95, 0.9, 0.85],
  "glassType": "martini glass|rocks glass|highball|coupe|wine glass|beer glass|unknown|null",
  "genieDescription": "Your mystical Genie description here in character"
}

Rules for genieDescription based on mode:
- bottles: Describe what you sense in a mystical way. Mention brand names if detected. Hint at cocktail possibilities.
- preparedDrink: Describe the drink poetically — color, likely taste, guess the name. Be dramatic and mystical.
- emptyGlass: Express mock horror at the empty vessel. Identify the glass type. Promise to fill it with magic from your database.
- unclear: Apologize mystically, ask for better photos of their spirits.

Rules for detection:
- bottles/ingredients: Only include what you can actually see. Do NOT invent brands.
- drinks: Suggest 3 cocktails possible from detected ingredients
- If mode is emptyGlass or unclear, bottles/ingredients/drinks can be empty arrays
- genieDescription must be 2-3 sentences maximum, fun and in character

Return ONLY the JSON object. No markdown, no extra text.''';

  Future<VisionAnalysisResult> analyzeImages(List<Uint8List> images) async {
    if (images.isEmpty) {
      return VisionAnalysisResult.withError('No images provided');
    }

    if (_apiKey.isEmpty) {
      return VisionAnalysisResult.withError(
          'API key not set. Run with --dart-define=ANTHROPIC_API_KEY=sk-ant-...');
    }

    final clamped = images.take(_maxImages).toList();

    try {
      final imageBlocks = <Map<String, dynamic>>[];
      for (final bytes in clamped) {
        final base64 = base64Encode(bytes);
        imageBlocks.add({
          'type': 'image',
          'source': {
            'type': 'base64',
            'media_type': 'image/jpeg',
            'data': base64,
          },
        });
      }

      imageBlocks.add({
        'type': 'text',
        'text':
            'I am sending you ${clamped.length} image(s). Analyze ALL of them together and return the JSON as instructed.',
      });

      final body = jsonEncode({
        'model': _model,
        'max_tokens': 1024,
        'system': _systemPrompt,
        'messages': [
          {'role': 'user', 'content': imageBlocks}
        ],
      });

      final response = await http.post(
        Uri.parse(_endpoint),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': _apiKey,
          'anthropic-version': '2023-06-01',
        },
        body: body,
      );

      if (response.statusCode != 200) {
        debugPrint('Claude API error: ${response.body}');
        return VisionAnalysisResult.withError(
            'API error ${response.statusCode}');
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final content = decoded['content'] as List<dynamic>;
      final text = content
          .whereType<Map<String, dynamic>>()
          .where((b) => b['type'] == 'text')
          .map((b) => b['text'] as String)
          .join('');

      final clean = text
          .replaceAll(RegExp(r'```json\s*'), '')
          .replaceAll(RegExp(r'```\s*'), '')
          .trim();

      Map<String, dynamic> parsed;
      try {
        parsed = jsonDecode(clean) as Map<String, dynamic>;
      } catch (_) {
        debugPrint('JSON parse error: $clean');
        return VisionAnalysisResult.withError('Could not understand response');
      }

      final modeStr = parsed['mode'] as String? ?? 'unclear';
      final mode = switch (modeStr) {
        'bottles' => GenieMode.bottles,
        'preparedDrink' => GenieMode.preparedDrink,
        'emptyGlass' => GenieMode.emptyGlass,
        _ => GenieMode.unclear,
      };

      final ingredients =
          List<String>.from(parsed['ingredients'] as List? ?? []);
      final bottles = List<String>.from(parsed['bottles'] as List? ?? []);
      final drinkNames =
          List<String>.from(parsed['drinks'] as List? ?? []);
      final confidence = (parsed['confidence'] as List? ?? [])
          .map((e) => (e as num).toDouble())
          .toList();
      final genieDescription =
          parsed['genieDescription'] as String? ?? '...';
      final glassType = parsed['glassType'] as String?;

      // Upgrade drink names → CocktailDB objects
      final upgradedDrinks = await _db.lookupMultipleByName(drinkNames);

      return VisionAnalysisResult(
        ingredients: ingredients,
        bottles: bottles,
        drinks: upgradedDrinks,
        confidence: confidence,
        genieDescription: genieDescription,
        mode: mode,
        detectedGlassType: glassType,
        imageCount: clamped.length,
      );
    } catch (e) {
      debugPrint('VisionService error: $e');
      return VisionAnalysisResult.withError('Something went wrong: $e');
    }
  }
}