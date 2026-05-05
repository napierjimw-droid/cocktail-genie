import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../services/openai_vision_service.dart';
import '../services/cocktail_db_service.dart';
import '../widgets/glass_icons.dart';
import 'drink_detail_screen.dart';
import 'info/about_page.dart';
import 'info/privacy_page.dart';
import 'info/legal_page.dart';
import 'info/contact_page.dart';
import 'info/refunds_page.dart';
import 'info/feedback_page.dart';
import '../services/storage_service.dart';

// ── Shared Claude helper ────────────────────────────────────────────────────
const _claudeEndpoint = 'https://api.anthropic.com/v1/messages';
const _claudeKey = String.fromEnvironment('ANTHROPIC_API_KEY');
const _claudeModel = 'claude-opus-4-5';

Future<String> _callClaude(String system, String userMessage) async {
  final body = jsonEncode({
    'model': _claudeModel,
    'max_tokens': 800,
    'system': system,
    'messages': [
      {'role': 'user', 'content': userMessage}
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

// ═══════════════════════════════════════════════════════════════════════════
// ANALYSIS RESULT SCREEN
// ═══════════════════════════════════════════════════════════════════════════

class AnalysisResultScreen extends StatefulWidget {
  final VisionAnalysisResult result;
  final List<Uint8List> allImages;

  const AnalysisResultScreen({
    super.key,
    required this.result,
    required this.allImages,
  });

  @override
  State<AnalysisResultScreen> createState() => _AnalysisResultScreenState();
}

class _AnalysisResultScreenState extends State<AnalysisResultScreen> {
  final TextEditingController _askController = TextEditingController();
  String? _genieAnswer;
  bool _askingGenie = false;
  bool _showAskInput = false;

@override
void initState() {
  super.initState();
  _saveToJourney();
  // save ingredients to My Bar
  _saveIngredients();
}

Future<void> _saveToJourney() async {
  final entry = {
    'id': DateTime.now().millisecondsSinceEpoch.toString(),
    'date': DateTime.now().toString().substring(0, 16),
    'description': widget.result.genieDescription,
    'bottles': widget.result.bottles,
    'ingredients': widget.result.ingredients,
  };
  await StorageService.addJourneyEntry(entry);
}

Future<void> _saveIngredients() async {
  final all = [...widget.result.bottles, ...widget.result.ingredients];
  if (all.isNotEmpty) await StorageService.addIngredients(all);
}

  @override
  void dispose() {
    _askController.dispose();
    super.dispose();
  }

  Future<void> _askGenie(String question) async {
    if (question.trim().isEmpty) return;
    setState(() { _askingGenie = true; _genieAnswer = null; });

    final ctx = [
      if (widget.result.bottles.isNotEmpty)
        'Bottles: ${widget.result.bottles.join(', ')}',
      if (widget.result.ingredients.isNotEmpty)
        'Ingredients: ${widget.result.ingredients.join(', ')}',
      if (widget.result.genieDescription.isNotEmpty)
        'Scene: ${widget.result.genieDescription}',
    ].join('. ');

    try {
      final answer = await _callClaude(
        'You are the Cocktail Genie - mystical, witty, knowledgeable. '
        'Answer in character - fun but accurate. 3-4 sentences max. '
        'Context about what was detected: $ctx',
        question,
      );
      if (mounted) setState(() { _genieAnswer = answer; _askingGenie = false; });
    } catch (e) {
      if (mounted) {
        setState(() {
          _genieAnswer = 'The spirits are momentarily unclear... try again!';
          _askingGenie = false;
        });
      }
    }
  }

  void _openPage(Widget page) =>
      Navigator.push(context, MaterialPageRoute(builder: (_) => page));

  @override
  Widget build(BuildContext context) {
    final t = Provider.of<LanguageProvider>(context).t;
    final result = widget.result;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.8,
            colors: [Color(0xFF2d0060), Color(0xFF0d0030)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCollage(),
                      const SizedBox(height: 20),
                      _buildGenieDescription(result),
                      const SizedBox(height: 20),
                      if (result.bottles.isNotEmpty || result.ingredients.isNotEmpty)
                        _buildWhatGenieSees(result),
                      const SizedBox(height: 24),
                      _buildActionButtons(t, result),
                      const SizedBox(height: 24),
                      if (_showAskInput) _buildAskGenieInput(),
                      if (_genieAnswer != null) _buildGenieAnswer(),
                      const SizedBox(height: 24),
                      _buildFooter(t),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1a0040),
        border: const Border(bottom: BorderSide(color: Colors.cyan, width: 1.5)),
        boxShadow: [BoxShadow(color: Colors.cyan.withValues(alpha: 0.2), blurRadius: 14, offset: const Offset(0, 3))],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(999), border: Border.all(color: Colors.cyan)),
              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.arrow_back, color: Colors.cyan, size: 15),
                SizedBox(width: 5),
                Text('Back', style: TextStyle(color: Colors.cyan, fontSize: 13)),
              ]),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text('🧞 Genie Reveals...',
                style: GoogleFonts.cinzel(fontSize: 18, color: Colors.cyan, letterSpacing: 1.5,
                    shadows: const [Shadow(color: Colors.cyan, blurRadius: 8)])),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(999), border: Border.all(color: const Color(0xFFFFD700))),
            child: const Row(mainAxisSize: MainAxisSize.min, children: [
              Text('🪙', style: TextStyle(fontSize: 12)),
              SizedBox(width: 3),
              Text('100', style: TextStyle(color: Color(0xFFFFD700), fontSize: 12, fontWeight: FontWeight.bold)),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildCollage() {
    final images = widget.allImages;
    if (images.isEmpty) return const SizedBox.shrink();
    if (images.length == 1) return _collageImage(images[0], double.infinity, 200);
    return LayoutBuilder(builder: (context, constraints) {
      final w = (constraints.maxWidth - 8) / 2;
      const h = 150.0;
      return Column(children: [
        Row(children: [
          _collageImage(images[0], w, h),
          const SizedBox(width: 8),
          images.length > 1 ? _collageImage(images[1], w, h) : _emptySlot(w, h),
        ]),
        if (images.length > 2) ...[
          const SizedBox(height: 8),
          Row(children: [
            _collageImage(images[2], w, h),
            const SizedBox(width: 8),
            images.length > 3 ? _collageImage(images[3], w, h) : _emptySlot(w, h),
          ]),
        ],
      ]);
    });
  }

  Widget _collageImage(Uint8List bytes, double w, double h) {
    return Container(
      width: w, height: h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.cyan.withValues(alpha: 0.5)),
        boxShadow: [BoxShadow(color: Colors.cyan.withValues(alpha: 0.15), blurRadius: 10)],
      ),
      child: ClipRRect(borderRadius: BorderRadius.circular(11), child: Image.memory(bytes, fit: BoxFit.cover)),
    );
  }

  Widget _emptySlot(double w, double h) {
    return Container(
      width: w, height: h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.cyan.withValues(alpha: 0.15)),
        color: Colors.cyan.withValues(alpha: 0.03),
      ),
    );
  }

  Widget _buildGenieDescription(VisionAnalysisResult result) {
    final icon = switch (result.mode) {
      GenieMode.bottles => '🧞',
      GenieMode.preparedDrink => '🍹',
      GenieMode.emptyGlass => '😱',
      GenieMode.unclear => '🔮',
    };
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFd4af37).withValues(alpha: 0.5)),
        color: const Color(0xFFd4af37).withValues(alpha: 0.06),
        boxShadow: [BoxShadow(color: const Color(0xFFd4af37).withValues(alpha: 0.1), blurRadius: 20)],
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(icon, style: const TextStyle(fontSize: 32)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            result.genieDescription.isEmpty ? 'The spirits speak...' : result.genieDescription,
            style: GoogleFonts.playfairDisplay(color: const Color(0xFFd4af37), fontSize: 15, fontStyle: FontStyle.italic, height: 1.5),
          ),
          const SizedBox(height: 8),
          Text('📸 ${result.imageCount} image${result.imageCount != 1 ? 's' : ''} analyzed',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 11)),
        ])),
      ]),
    );
  }

  Widget _buildWhatGenieSees(VisionAnalysisResult result) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.cyan.withValues(alpha: 0.25)),
        color: Colors.cyan.withValues(alpha: 0.04),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('I can see…', style: GoogleFonts.cinzel(color: Colors.cyan, fontSize: 14, letterSpacing: 1)),
        const SizedBox(height: 12),
        if (result.bottles.isNotEmpty) ...[
          Text('🍾 Bottles', style: TextStyle(color: Colors.cyan.withValues(alpha: 0.7), fontSize: 11, letterSpacing: 1)),
          const SizedBox(height: 6),
          Wrap(spacing: 6, runSpacing: 6, children: result.bottles.map((b) => _chip(b, Colors.cyan)).toList()),
          const SizedBox(height: 12),
        ],
        if (result.ingredients.isNotEmpty) ...[
          Text('🍋 Ingredients', style: TextStyle(color: const Color(0xFFCC88FF).withValues(alpha: 0.8), fontSize: 11, letterSpacing: 1)),
          const SizedBox(height: 6),
          Wrap(spacing: 6, runSpacing: 6, children: result.ingredients.map((i) => _chip(i, const Color(0xFFCC88FF))).toList()),
        ],
      ]),
    );
  }

  Widget _chip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.5)),
        color: color.withValues(alpha: 0.08),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 12)),
    );
  }

  Widget _buildActionButtons(String Function(String) t, VisionAnalysisResult result) {
    return Column(children: [
      _actionButton(
        icon: MartiniGlassIcon(color: const Color(0xFFd4af37), size: 38),
        label: 'Genie Suggests',
        subtitle: 'Cocktails from your ingredients',
        color: const Color(0xFFd4af37),
        onTap: result.drinks.isNotEmpty || result.ingredients.isNotEmpty
            ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => GenieSuggestsScreen(result: result)))
            : null,
      ),
      const SizedBox(height: 12),
      _actionButton(
        icon: HurricaneGlassIcon(color: const Color(0xFFCC88FF), size: 38),
        label: 'Crazy Cocktail',
        subtitle: 'Let Genie invent something wild',
        color: const Color(0xFFCC88FF),
        onTap: result.ingredients.isNotEmpty || result.bottles.isNotEmpty
            ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => CrazyCoktailScreen(result: result)))
            : null,
      ),
      const SizedBox(height: 12),
      _actionButton(
        icon: ChampagneFluteIcon(color: Colors.cyan, size: 38),
        label: 'Ask Genie',
        subtitle: 'Any question about your drinks',
        color: Colors.cyan,
        onTap: () => setState(() => _showAskInput = !_showAskInput),
      ),
    ]);
  }

  Widget _actionButton({
    required Widget icon, required String label, required String subtitle,
    required Color color, required VoidCallback? onTap,
  }) {
    final disabled = onTap == null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: disabled ? Colors.white12 : color.withValues(alpha: 0.7)),
          color: disabled ? Colors.white.withValues(alpha: 0.02) : color.withValues(alpha: 0.08),
          boxShadow: disabled ? [] : [BoxShadow(color: color.withValues(alpha: 0.15), blurRadius: 12)],
        ),
        child: Row(children: [
          icon,
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: GoogleFonts.cinzel(color: disabled ? Colors.white24 : color, fontSize: 15, letterSpacing: 1)),
            const SizedBox(height: 2),
            Text(subtitle, style: TextStyle(color: disabled ? Colors.white12 : Colors.white.withValues(alpha: 0.5), fontSize: 11)),
          ])),
          Icon(Icons.arrow_forward_ios, color: disabled ? Colors.white12 : color, size: 14),
        ]),
      ),
    );
  }

  Widget _buildAskGenieInput() {
    return Column(children: [
      const SizedBox(height: 8),
      Row(children: [
        Expanded(
          child: TextField(
            controller: _askController,
            style: const TextStyle(color: Colors.cyan, fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Ask the Genie anything...',
              hintStyle: const TextStyle(color: Colors.white38, fontSize: 12),
              filled: true, fillColor: const Color(0xFF1a0040), isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Colors.cyan)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Colors.cyan)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Colors.cyan, width: 2)),
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => _askGenie(_askController.text),
          child: Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.cyan.withValues(alpha: 0.15),
              border: Border.all(color: Colors.cyan),
              boxShadow: [BoxShadow(color: Colors.cyan.withValues(alpha: 0.3), blurRadius: 8)],
            ),
            child: _askingGenie
                ? const Padding(padding: EdgeInsets.all(10), child: CircularProgressIndicator(color: Colors.cyan, strokeWidth: 2))
                : const Icon(Icons.send_rounded, color: Colors.cyan, size: 20),
          ),
        ),
      ]),
    ]);
  }

  Widget _buildGenieAnswer() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.cyan.withValues(alpha: 0.4)),
        color: const Color(0xFF0d0030).withValues(alpha: 0.8),
        boxShadow: [BoxShadow(color: Colors.cyan.withValues(alpha: 0.2), blurRadius: 12)],
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('🧞', style: TextStyle(fontSize: 24)),
        const SizedBox(width: 10),
        Expanded(child: Text(_genieAnswer ?? '',
            style: GoogleFonts.playfairDisplay(color: Colors.cyan, fontSize: 14, fontStyle: FontStyle.italic, height: 1.5))),
      ]),
    );
  }

  Widget _buildFooter(String Function(String) t) {
    return Column(children: [
      Container(
        height: 1,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Colors.transparent, Colors.cyan, Color(0xFF9000ff), Colors.cyan, Colors.transparent]),
          boxShadow: [BoxShadow(color: Colors.cyan.withValues(alpha: 0.3), blurRadius: 8)],
        ),
      ),
      const SizedBox(height: 8),
      Wrap(spacing: 2, children: [
        _footerLink(t('about'), () => _openPage(const AboutPage())),
        _footerLink(t('privacy'), () => _openPage(const PrivacyPage())),
        _footerLink(t('legal'), () => _openPage(const LegalPage())),
        _footerLink(t('contact'), () => _openPage(const ContactPage())),
        _footerLink(t('refunds'), () => _openPage(const RefundsPage())),
        _footerLink(t('feedback'), () => _openPage(const FeedbackPage())),
      ]),
      const SizedBox(height: 4),
      Text(t('drink_responsibly'), style: const TextStyle(color: Colors.white38, fontSize: 11)),
      const SizedBox(height: 4),
      Text(t('copyright'), style: const TextStyle(color: Colors.white38, fontSize: 11)),
      const SizedBox(height: 100),
    ]);
  }

  Widget _footerLink(String label, VoidCallback onTap) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(minimumSize: Size.zero, padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4)),
      child: Text(label, style: const TextStyle(color: Colors.cyan, fontSize: 11)),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// GENIE SUGGESTS SCREEN
// ═══════════════════════════════════════════════════════════════════════════

class GenieSuggestsScreen extends StatefulWidget {
  final VisionAnalysisResult result;
  const GenieSuggestsScreen({super.key, required this.result});

  @override
  State<GenieSuggestsScreen> createState() => _GenieSuggestsScreenState();
}

class _GenieSuggestsScreenState extends State<GenieSuggestsScreen> {
  final _db = CocktailDbService();
  final Map<String, Map<String, dynamic>> _fullDrinks = {};

  @override
  void initState() {
    super.initState();
    _loadFullDrinks();
  }

  Future<void> _loadFullDrinks() async {
    for (final drink in widget.result.drinks) {
      final id = drink['idDrink'] as String?;
      if (id != null) {
        final full = await _db.lookupById(id);
        if (full != null && mounted) {
          setState(() => _fullDrinks[id] = full);
        }
      }
    }
  }

  String _normalize(String s) => s.toLowerCase().trim();

  List<String> get _userHas => [
    ...widget.result.bottles,
    ...widget.result.ingredients,
  ].map(_normalize).toList();

  bool _userHasIngredient(String ingredient) {
    final norm = _normalize(ingredient);
    return _userHas.any((h) => h.contains(norm) || norm.contains(h));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(center: Alignment.topCenter, radius: 1.8, colors: [Color(0xFF2d0060), Color(0xFF0d0030)]),
        ),
        child: SafeArea(
          child: Column(children: [
            _header(context),
            Expanded(
              child: widget.result.drinks.isEmpty
                  ? _empty()
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: widget.result.drinks.length,
                      itemBuilder: (_, i) => _drinkCard(context, widget.result.drinks[i]),
                    ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1a0040),
        border: const Border(bottom: BorderSide(color: Color(0xFFd4af37), width: 1.5)),
        boxShadow: [BoxShadow(color: const Color(0xFFd4af37).withValues(alpha: 0.2), blurRadius: 14)],
      ),
      child: Row(children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(999), border: Border.all(color: const Color(0xFFd4af37))),
            child: const Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.arrow_back, color: Color(0xFFd4af37), size: 15),
              SizedBox(width: 5),
              Text('Back', style: TextStyle(color: Color(0xFFd4af37), fontSize: 13)),
            ]),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text('🧞 Genie Suggests',
            style: GoogleFonts.cinzel(fontSize: 18, color: const Color(0xFFd4af37), letterSpacing: 1.5))),
      ]),
    );
  }

  Widget _drinkCard(BuildContext context, Map<String, dynamic> drink) {
    final id = drink['idDrink'] as String?;
    final fullDrink = id != null ? _fullDrinks[id] : null;
    final allIngredients = fullDrink != null
        ? CocktailDbService.extractIngredients(fullDrink)
        : <String>[];
    final haveList = allIngredients.where((i) => _userHasIngredient(i)).toList();
    final missingList = allIngredients.where((i) => !_userHasIngredient(i)).toList();

    return GestureDetector(
      onTap: () {
        if (id != null) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => DrinkDetailScreen(drinkId: id)));
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFd4af37).withValues(alpha: 0.4)),
          color: const Color(0xFFd4af37).withValues(alpha: 0.05),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(drink['strDrinkThumb'] ?? '', width: 70, height: 70, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(width: 70, height: 70, color: const Color(0xFF1a0033),
                      child: const Center(child: Text('🍸', style: TextStyle(fontSize: 28))))),
            ),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(drink['strDrink'] ?? '',
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
              if (drink['strCategory'] != null) ...[
                const SizedBox(height: 4),
                Text(drink['strCategory'],
                    style: TextStyle(color: const Color(0xFFd4af37).withValues(alpha: 0.7), fontSize: 12)),
              ],
              if (fullDrink == null) ...[
                const SizedBox(height: 4),
                Text('Loading ingredients...',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.3), fontSize: 11)),
              ],
            ])),
            Icon(Icons.arrow_forward_ios, color: const Color(0xFFd4af37).withValues(alpha: 0.6), size: 14),
          ]),

          if (fullDrink != null && allIngredients.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black.withValues(alpha: 0.2),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                if (haveList.isNotEmpty)
                  Wrap(spacing: 6, runSpacing: 4,
                      children: haveList.map((ing) => _ingredientChip(ing, true)).toList()),
                if (missingList.isNotEmpty) ...[
                  if (haveList.isNotEmpty) const SizedBox(height: 4),
                  Wrap(spacing: 6, runSpacing: 4,
                      children: missingList.map((ing) => _ingredientChip(ing, false)).toList()),
                ],
              ]),
            ),
            const SizedBox(height: 6),
            Text(
              missingList.isEmpty ? '✅ You have everything!' : '❌ Missing ${missingList.length} ingredient${missingList.length > 1 ? 's' : ''}',
              style: TextStyle(
                color: missingList.isEmpty ? Colors.greenAccent : Colors.orangeAccent,
                fontSize: 11, fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ]),
      ),
    );
  }

  Widget _ingredientChip(String label, bool have) {
    final color = have ? Colors.greenAccent : Colors.orangeAccent;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.4)),
        color: color.withValues(alpha: 0.08),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(have ? '✅' : '❌', style: const TextStyle(fontSize: 10)),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(color: color, fontSize: 11)),
      ]),
    );
  }

  Widget _empty() {
    return const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text('🧞', style: TextStyle(fontSize: 60)),
      SizedBox(height: 16),
      Text('No cocktails found for\nthese ingredients',
          textAlign: TextAlign.center, style: TextStyle(color: Colors.white54, fontSize: 15)),
    ]));
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// CRAZY COCKTAIL SCREEN
// ═══════════════════════════════════════════════════════════════════════════

class CrazyCoktailScreen extends StatefulWidget {
  final VisionAnalysisResult result;
  const CrazyCoktailScreen({super.key, required this.result});

  @override
  State<CrazyCoktailScreen> createState() => _CrazyCoktailScreenState();
}

class _CrazyCoktailScreenState extends State<CrazyCoktailScreen> {
  bool _loading = true;
  String? _crazyRecipe;
  String? _error;

  @override
  void initState() {
    super.initState();
    _generateCrazyDrink();
  }

  Future<void> _generateCrazyDrink() async {
    final ingredients = [...widget.result.bottles, ...widget.result.ingredients];
    if (ingredients.isEmpty) {
      setState(() { _error = 'No ingredients detected!'; _loading = false; });
      return;
    }
    try {
      final recipe = await _callClaude(
        'You are the Cocktail Genie - creative, mystical, wildly imaginative. '
        'Invent a unique cocktail using ONLY the provided ingredients. '
        'Format: dramatic name, mystical quote, description, ingredients with measurements, method steps, glass type. '
        'Make it magical and dramatic.',
        'Create a wild unique cocktail using ONLY: ${ingredients.join(', ')}',
      );
      if (mounted) setState(() { _crazyRecipe = recipe; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = 'The spirits are overwhelmed... try again!'; _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(center: Alignment.topCenter, radius: 1.8, colors: [Color(0xFF2d0060), Color(0xFF0d0030)]),
        ),
        child: SafeArea(
          child: Column(children: [
            Container(
              height: 58,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: const BoxDecoration(
                color: Color(0xFF1a0040),
                border: Border(bottom: BorderSide(color: Color(0xFFCC88FF), width: 1.5)),
              ),
              child: Row(children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(999), border: Border.all(color: const Color(0xFFCC88FF))),
                    child: const Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.arrow_back, color: Color(0xFFCC88FF), size: 15),
                      SizedBox(width: 5),
                      Text('Back', style: TextStyle(color: Color(0xFFCC88FF), fontSize: 13)),
                    ]),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text('🔮 Crazy Cocktail',
                    style: GoogleFonts.cinzel(fontSize: 18, color: const Color(0xFFCC88FF), letterSpacing: 1.5))),
                GestureDetector(
                  onTap: () { setState(() { _loading = true; _crazyRecipe = null; }); _generateCrazyDrink(); },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(999), border: Border.all(color: const Color(0xFFCC88FF))),
                    child: const Text('🔄 New', style: TextStyle(color: Color(0xFFCC88FF), fontSize: 12)),
                  ),
                ),
              ]),
            ),
            Expanded(
              child: _loading
                  ? const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text('🔮', style: TextStyle(fontSize: 60)),
                      SizedBox(height: 20),
                      CircularProgressIndicator(color: Color(0xFFCC88FF)),
                      SizedBox(height: 16),
                      Text('The Genie is conjuring something wild...',
                          style: TextStyle(color: Color(0xFFCC88FF), fontStyle: FontStyle.italic)),
                    ]))
                  : _error != null
                      ? Center(child: Text(_error!, style: const TextStyle(color: Colors.white54)))
                      : SingleChildScrollView(
                          padding: const EdgeInsets.all(20),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFCC88FF).withValues(alpha: 0.4)),
                              color: const Color(0xFFCC88FF).withValues(alpha: 0.05),
                            ),
                            child: Text(_crazyRecipe ?? '',
                                style: GoogleFonts.playfairDisplay(color: Colors.white, fontSize: 15, height: 1.7)),
                          ),
                        ),
            ),
          ]),
        ),
      ),
    );
  }
}