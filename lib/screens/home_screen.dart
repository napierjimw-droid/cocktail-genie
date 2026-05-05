import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../services/cocktail_db_service.dart';
import '../widgets/drink_card.dart';
import '../widgets/genie_avatar.dart';
import 'info/about_page.dart';
import 'info/privacy_page.dart';
import 'info/legal_page.dart';
import 'info/contact_page.dart';
import 'info/refunds_page.dart';
import 'info/feedback_page.dart';
import 'drink_detail_screen.dart';
import 'genie_camera_screen.dart';

const List<Map<String, String>> kCategories = [
  {"id": "Ordinary_Drink",      "label": "cat_spirit"},
  {"id": "Cocktail",            "label": "cat_refreshing"},
  {"id": "Shake",               "label": "cat_frozen"},
  {"id": "Other_/_Unknown",     "label": "cat_experimental"},
  {"id": "Cocoa",               "label": "cat_dessert"},
  {"id": "Shot",                "label": "cat_strong"},
  {"id": "Coffee_/_Tea",        "label": "cat_herbal"},
  {"id": "Punch_/_Party_Drink", "label": "cat_tiki"},
  {"id": "Soft_Drink",          "label": "cat_sparkling"},
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final _db = CocktailDbService();

  bool _categoriesOpen = false;
  bool _langOpen = false;
  String? _selectedCategoryId;
  List<dynamic> _searchResults = [];
  List<dynamic> _suggestions = [];
  List<dynamic> _categoryResults = [];
  bool _loading = false;
  bool _showSuggestions = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _onSearchChanged(String value) async {
    if (value.length < 2) {
      setState(() { _suggestions = []; _showSuggestions = false; });
      return;
    }
    final results = await _db.autocomplete(value);
    setState(() { _suggestions = results; _showSuggestions = true; });
  }

  Future<void> _search(String query) async {
    if (query.isEmpty) return;
    setState(() {
      _loading = true;
      _showSuggestions = false;
      _categoryResults = [];
      _selectedCategoryId = null;
    });
    final results = await _db.searchByName(query);
    setState(() { _searchResults = results; _loading = false; });
  }

  Future<void> _selectCategory(String categoryId) async {
    setState(() {
      _selectedCategoryId = categoryId;
      _categoriesOpen = false;
      _loading = true;
      _searchResults = [];
      _searchController.clear();
      _showSuggestions = false;
    });
    final results = await _db.filterByCategory(categoryId);
    setState(() { _categoryResults = results; _loading = false; });
  }

  void _openDrink(String id) => Navigator.push(context,
      MaterialPageRoute(builder: (_) => DrinkDetailScreen(drinkId: id)));

  void _openPage(Widget page) =>
      Navigator.push(context, MaterialPageRoute(builder: (_) => page));

  void _openCamera() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => const GenieCameraScreen(),
        transitionsBuilder: (_, animation, __, child) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
              parent: animation, curve: Curves.easeOutCubic)),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final t = lang.t;

    return GestureDetector(
      onTap: () => setState(() {
        _langOpen = false;
        _showSuggestions = false;
      }),
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.8,
                  colors: [Color(0xFF2d0060), Color(0xFF0d0030)],
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  _buildTopBar(t, lang),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          if (_categoriesOpen) _buildCategoriesDropdown(t),
                          if (_showSuggestions && _suggestions.isNotEmpty)
                            _buildSuggestions(),
                          _buildHero(t),
                          _buildResults(t),
                          _buildFooter(t),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_langOpen) _buildLangDropdown(lang),
          ],
        ),
      ),
    );
  }

  // ── Top bar ──────────────────────────────────────────────────────────────────

  Widget _buildTopBar(String Function(String) t, LanguageProvider lang) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1a0040),
        border: const Border(
            bottom: BorderSide(color: Colors.cyan, width: 1.5)),
        boxShadow: [BoxShadow(
          color: Colors.cyan.withValues(alpha: 0.2),
          blurRadius: 14,
          offset: const Offset(0, 3),
        )],
      ),
      child: Row(
        children: [
          // Categories
          GestureDetector(
            onTap: () => setState(() {
              _categoriesOpen = !_categoriesOpen;
              _langOpen = false;
            }),
            child: _pill(child: Text(
              '🍹 ${_categoriesOpen ? "▲" : "▼"}',
              style: const TextStyle(color: Colors.white, fontSize: 13),
            )),
          ),
          const SizedBox(width: 8),

          // Search — centered
          Expanded(
            child: Center(
              child: SizedBox(
                width: 320,
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Color(0xFF00ffff), fontSize: 13),
                  onChanged: _onSearchChanged,
                  onSubmitted: _search,
                  decoration: InputDecoration(
                    hintText: t('search'),
                    hintStyle: const TextStyle(color: Colors.white38, fontSize: 12),
                    filled: true,
                    fillColor: const Color(0xFF1a0040),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.cyan),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.cyan),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.cyan, width: 2),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search, color: Colors.cyan, size: 16),
                      onPressed: () => _search(_searchController.text),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Token pill
          _pill(child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('🪙', style: TextStyle(fontSize: 12)),
              SizedBox(width: 3),
              Text('100', style: TextStyle(
                color: Color(0xFFFFD700),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              )),
            ],
          )),
          const SizedBox(width: 6),

          // Language
          GestureDetector(
            onTap: () => setState(() {
              _langOpen = !_langOpen;
              _categoriesOpen = false;
            }),
            child: _pill(child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.language, color: Colors.cyan, size: 13),
                const SizedBox(width: 3),
                Text(lang.lang, style: const TextStyle(
                    color: Color(0xFF7df9ff), fontSize: 12)),
                const Icon(Icons.arrow_drop_down, color: Colors.cyan, size: 13),
              ],
            )),
          ),
          const SizedBox(width: 6),

          // Sign in
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF14003C),
              border: Border.all(color: Colors.cyan, width: 1.5),
              boxShadow: [BoxShadow(
                  color: Colors.cyan.withValues(alpha: 0.25), blurRadius: 6)],
            ),
            child: const Center(
                child: Text('👤', style: TextStyle(fontSize: 14))),
          ),
        ],
      ),
    );
  }

  Widget _pill({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.cyan.withValues(alpha: 0.7)),
        color: Colors.cyan.withValues(alpha: 0.07),
      ),
      child: child,
    );
  }

  // ── Categories dropdown ───────────────────────────────────────────────────────

  Widget _buildCategoriesDropdown(String Function(String) t) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1a0040),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.cyan.withValues(alpha: 0.3)),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: kCategories.map((cat) {
          final selected = _selectedCategoryId == cat['id'];
          return GestureDetector(
            onTap: () => _selectCategory(cat['id']!),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: Colors.cyan),
                color: selected
                    ? Colors.cyan.withValues(alpha: 0.2)
                    : Colors.transparent,
              ),
              child: Text(t(cat['label']!),
                  style: const TextStyle(color: Colors.white, fontSize: 12)),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Autocomplete ──────────────────────────────────────────────────────────────

  Widget _buildSuggestions() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 60),
      decoration: BoxDecoration(
        color: const Color(0xFF1a0040),
        border: Border.all(color: Colors.cyan.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: _suggestions.map<Widget>((drink) {
          return GestureDetector(
            onTap: () {
              _searchController.text = drink['strDrink'];
              _search(drink['strDrink']);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.white12))),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(drink['strDrinkThumb'],
                        width: 36, height: 36, fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 10),
                  Text(drink['strDrink'],
                      style: const TextStyle(color: Colors.cyan)),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Hero ──────────────────────────────────────────────────────────────────────

  Widget _buildHero(String Function(String) t) {
  return Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title
        Text(
          t('cocktail_genie'),
          style: GoogleFonts.cinzel(
            fontSize: 38,
            fontWeight: FontWeight.w600,
            color: Colors.cyan,
            letterSpacing: 3,
            shadows: const [
              Shadow(color: Colors.cyan, blurRadius: 16),
              Shadow(color: Colors.cyan, blurRadius: 32),
            ],
          ),
        ),

        // Gold divider
        Container(
          width: 180,
          height: 1,
          margin: const EdgeInsets.only(top: 4, bottom: 0),
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.transparent,
              Color(0xFFd4af37),
              Color(0xFFd4af37),
              Colors.transparent,
            ]),
          ),
        ),

        // Genie
        GenieAvatar(onTap: _openCamera),

        // Tagline
        Transform.translate(
          offset: const Offset(0, -40),
          child: Text(
            t('tagline'),
            style: const TextStyle(
              color: Color(0xFF7df9ff),
              fontSize: 14,
              fontStyle: FontStyle.italic,
              letterSpacing: 1,
            ),
          ),
        ),
      ],
    ),
  );
}

  // ── Results ───────────────────────────────────────────────────────────────────

  Widget _buildResults(String Function(String) t) {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.all(40),
        child: CircularProgressIndicator(color: Colors.cyan),
      );
    }
    if (_categoryResults.isNotEmpty && _searchResults.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemCount: _categoryResults.length,
          itemBuilder: (_, i) => DrinkGridCard(
            drink: Map<String, dynamic>.from(_categoryResults[i]),
            onTap: () => _openDrink(_categoryResults[i]['idDrink']),
          ),
        ),
      );
    }
    if (_searchResults.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: _searchResults.map<Widget>((drink) {
            return DrinkCard(
              drink: Map<String, dynamic>.from(drink),
              onTap: () => _openDrink(drink['idDrink']),
            );
          }).toList(),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  // ── Footer ────────────────────────────────────────────────────────────────────

  Widget _buildFooter(String Function(String) t) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Container(
          height: 1,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [
              Colors.transparent, Colors.cyan,
              Color(0xFF9000ff), Colors.cyan, Colors.transparent,
            ]),
            boxShadow: [BoxShadow(
                color: Colors.cyan.withValues(alpha: 0.3), blurRadius: 8)],
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 2,
          children: [
            _footerLink(t('about'), () => _openPage(const AboutPage())),
            _footerLink(t('privacy'), () => _openPage(const PrivacyPage())),
            _footerLink(t('legal'), () => _openPage(const LegalPage())),
            _footerLink(t('contact'), () => _openPage(const ContactPage())),
            _footerLink(t('refunds'), () => _openPage(const RefundsPage())),
            _footerLink(t('feedback'), () => _openPage(const FeedbackPage())),
          ],
        ),
        const SizedBox(height: 4),
        Text(t('drink_responsibly'),
            style: const TextStyle(color: Colors.white38, fontSize: 11)),
        const SizedBox(height: 4),
        Text(t('copyright'),
            style: const TextStyle(color: Colors.white38, fontSize: 11)),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _footerLink(String label, VoidCallback onTap) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        minimumSize: Size.zero,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      ),
      child: Text(label,
          style: const TextStyle(color: Colors.cyan, fontSize: 11)),
    );
  }

  // ── Language dropdown ─────────────────────────────────────────────────────────

  Widget _buildLangDropdown(LanguageProvider lang) {
    return Positioned(
      top: 64,
      right: 46,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF1a0040),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.cyan),
            boxShadow: [BoxShadow(
                color: Colors.cyan.withValues(alpha: 0.3), blurRadius: 12)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: lang.languages.map((code) {
              final selected = code == lang.lang;
              return GestureDetector(
                onTap: () {
                  lang.setLang(code);
                  setState(() => _langOpen = false);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: Colors.cyan),
                    color: selected
                        ? Colors.cyan.withValues(alpha: 0.2)
                        : Colors.transparent,
                  ),
                  child: Text(code,
                      style: const TextStyle(
                          color: Color(0xFF7df9ff), fontSize: 13)),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}