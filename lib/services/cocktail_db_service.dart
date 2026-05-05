import 'dart:convert';
import 'package:http/http.dart' as http;

const _base = 'https://www.thecocktaildb.com/api/json/v1/1';

class CocktailDbService {
  // ─── Search ────────────────────────────────────────────────────────────────

  /// Search cocktails by name — used for search bar + autocomplete
  Future<List<Map<String, dynamic>>> searchByName(String query) async {
    final res = await http.get(Uri.parse('$_base/search.php?s=$query'));
    final data = jsonDecode(res.body);
    return List<Map<String, dynamic>>.from(data['drinks'] ?? []);
  }

  /// Get first 6 suggestions for autocomplete
  Future<List<Map<String, dynamic>>> autocomplete(String query) async {
    final results = await searchByName(query);
    return results.take(6).toList();
  }

  // ─── Lookup ────────────────────────────────────────────────────────────────

  /// Get full drink details by ID — used for detail page
  Future<Map<String, dynamic>?> lookupById(String id) async {
    final res = await http.get(Uri.parse('$_base/lookup.php?i=$id'));
    final data = jsonDecode(res.body);
    final drinks = data['drinks'] as List?;
    return drinks?.isNotEmpty == true
        ? Map<String, dynamic>.from(drinks![0])
        : null;
  }

  /// Look up a cocktail by name — used after AI analysis
  /// Returns the first match or null
  Future<Map<String, dynamic>?> lookupByName(String name) async {
    final results = await searchByName(name);
    return results.isNotEmpty ? results.first : null;
  }

  /// Look up multiple cocktail names in parallel — used after AI analysis
  /// Mirrors your Next.js upgradedDrinks logic
  Future<List<Map<String, dynamic>>> lookupMultipleByName(
      List<String> names) async {
    final results = await Future.wait(
      names.map((name) => lookupByName(name)),
    );
    return results.whereType<Map<String, dynamic>>().toList();
  }

  // ─── Filter by ingredient ──────────────────────────────────────────────────

  /// Filter cocktails by a single ingredient
  /// Returns list of {idDrink, strDrink, strDrinkThumb}
  Future<List<Map<String, dynamic>>> filterByIngredient(
      String ingredient) async {
    final encoded = Uri.encodeComponent(ingredient);
    final res =
        await http.get(Uri.parse('$_base/filter.php?i=$encoded'));
    final data = jsonDecode(res.body);
    return List<Map<String, dynamic>>.from(data['drinks'] ?? []);
  }

  /// Find cocktails that match ALL given ingredients (full match)
  /// and cocktails that match most (near match — missing 1 or 2)
  Future<IngredientMatchResult> matchByIngredients(
      List<String> ingredients) async {
    if (ingredients.isEmpty) {
      return IngredientMatchResult(fullMatches: [], nearMatches: []);
    }

    // Query CocktailDB for each ingredient in parallel
    final perIngredient = await Future.wait(
      ingredients.map((ing) => filterByIngredient(ing)),
    );

    // Count how many ingredients each drink appears in
    final countMap = <String, int>{};
    final drinkMap = <String, Map<String, dynamic>>{};

    for (final list in perIngredient) {
      for (final drink in list) {
        final id = drink['idDrink'] as String;
        countMap[id] = (countMap[id] ?? 0) + 1;
        drinkMap[id] = drink;
      }
    }

    final total = ingredients.length;
    final fullMatches = <Map<String, dynamic>>[];
    final nearMatches = <NearMatch>[];

    for (final entry in countMap.entries) {
      final drink = drinkMap[entry.key]!;
      final count = entry.value;

      if (count == total) {
        fullMatches.add(drink);
      } else if (count >= total - 2 && total > 1) {
        // Missing 1 or 2 ingredients
        nearMatches.add(NearMatch(
          drink: drink,
          matchCount: count,
          totalIngredients: total,
          missingCount: total - count,
        ));
      }
    }

    // Sort near matches by how close they are
    nearMatches.sort((a, b) => b.matchCount.compareTo(a.matchCount));

    return IngredientMatchResult(
      fullMatches: fullMatches.take(10).toList(),
      nearMatches: nearMatches.take(5).toList(),
    );
  }

  // ─── Categories ───────────────────────────────────────────────────────────

  /// Filter by CocktailDB category name
  Future<List<Map<String, dynamic>>> filterByCategory(
      String categoryName) async {
    final encoded = Uri.encodeComponent(categoryName);
    final res =
        await http.get(Uri.parse('$_base/filter.php?c=$encoded'));
    final data = jsonDecode(res.body);
    return List<Map<String, dynamic>>.from(data['drinks'] ?? []);
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  /// Extract ingredients list from a full drink object
  static List<String> extractIngredients(Map<String, dynamic> drink) {
    final list = <String>[];
    for (int i = 1; i <= 15; i++) {
      final ing = drink['strIngredient$i'];
      final meas = drink['strMeasure$i'] ?? '';
      if (ing != null && ing.toString().isNotEmpty) {
        list.add('$meas $ing'.trim());
      }
    }
    return list;
  }

  /// Map our app category IDs to CocktailDB category names
  static const Map<String, String> categoryMap = {
    'sour': 'Sour_Cocktail',
    'spirit': 'Ordinary_Drink',
    'refreshing': 'Cocktail',
    'tiki': 'Punch_/_Party_Drink',
    'dessert': 'Homemade_Liqueur',
    'sparkling': 'Soft_Drink',
    'herbal': 'Cocktail',
    'strong': 'Shot',
    'frozen': 'Cocktail',
    'genie': 'Other_/_Unknown',
  };
}

// ─── Result models ─────────────────────────────────────────────────────────

class IngredientMatchResult {
  final List<Map<String, dynamic>> fullMatches;
  final List<NearMatch> nearMatches;

  IngredientMatchResult({
    required this.fullMatches,
    required this.nearMatches,
  });
}

class NearMatch {
  final Map<String, dynamic> drink;
  final int matchCount;
  final int totalIngredients;
  final int missingCount;

  NearMatch({
    required this.drink,
    required this.matchCount,
    required this.totalIngredients,
    required this.missingCount,
  });
  // ADD THESE TWO METHODS to your existing CocktailDbService class
// in lib/services/cocktail_db_service.dart
// Paste them before the closing } of the class

  static const _claudeEndpoint = 'https://api.anthropic.com/v1/messages';
  static const _claudeKey = String.fromEnvironment('ANTHROPIC_API_KEY');
  static const _claudeModel = 'claude-opus-4-5';

  /// Ask Genie any question about detected drinks
  Future<String> askGenie(String question, String ctx) async {
    final body = jsonEncode({
      'model': _claudeModel,
      'max_tokens': 512,
      'system': '''You are the Cocktail Genie — mystical, witty, knowledgeable about all spirits and cocktails.
Answer in your Genie character — mystical but informative, fun but accurate.
Keep answers to 3-4 sentences maximum. Context about what was detected: $ctx''',
      'messages': [
        {'role': 'user', 'content': question}
      ],
    });

    final response = await http.post(
      Uri.parse(_claudeEndpoint),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': _claudeKey,
        'anthropic-version': '2023-06-01',
      },
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception('API error ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final content = decoded['content'] as List<dynamic>;
    return content
        .whereType<Map<String, dynamic>>()
        .where((b) => b['type'] == 'text')
        .map((b) => b['text'] as String)
        .join('');
  }

  /// Generate a crazy unique cocktail from detected ingredients
  Future<String> generateCrazyDrink(List<String> ingredients) async {
    final ingredientList = ingredients.join(', ');

    final body = jsonEncode({
      'model': _claudeModel,
      'max_tokens': 800,
      'system': '''You are the Cocktail Genie — creative, mystical, and wildly imaginative.
Invent a completely unique, unexpected cocktail using ONLY the provided ingredients.
Format your response exactly like this:

✨ [DRAMATIC COCKTAIL NAME]

"[A mystical one-line quote about this drink]"

[2-3 sentence poetic description of the drink — color, taste, occasion]

📋 Ingredients:
• [ingredient with measurement]
• [ingredient with measurement]

🔮 Method:
1. [step]
2. [step]
3. [step]

🥂 Serve in: [glass type]

Make it creative, unexpected, and magical. The name should be dramatic and memorable.''',
      'messages': [
        {
          'role': 'user',
          'content':
              'Create a wild, unique cocktail using ONLY these ingredients: $ingredientList'
        }
      ],
    });

    final response = await http.post(
      Uri.parse(_claudeEndpoint),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': _claudeKey,
        'anthropic-version': '2023-06-01',
      },
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception('API error ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final content = decoded['content'] as List<dynamic>;
    return content
        .whereType<Map<String, dynamic>>()
        .where((b) => b['type'] == 'text')
        .map((b) => b['text'] as String)
        .join('');
  }
}
