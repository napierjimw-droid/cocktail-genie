import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/storage_service.dart';
import '../services/cocktail_db_service.dart';
import 'drink_detail_screen.dart';
import 'info/about_page.dart';
import 'info/privacy_page.dart';
import 'info/legal_page.dart';
import 'info/contact_page.dart';
import 'info/refunds_page.dart';
import 'info/feedback_page.dart';

class MyBarScreen extends StatefulWidget {
  const MyBarScreen({super.key});

  @override
  State<MyBarScreen> createState() => _MyBarScreenState();
}

class _MyBarScreenState extends State<MyBarScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openPage(Widget page) =>
      Navigator.push(context, MaterialPageRoute(builder: (_) => page));

  @override
  Widget build(BuildContext context) {
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1a0040),
                  border: const Border(bottom: BorderSide(color: Colors.cyan, width: 1.5)),
                  boxShadow: [BoxShadow(color: Colors.cyan.withValues(alpha: 0.2), blurRadius: 14)],
                ),
                child: Column(children: [
                  Text('🍾 My Bar',
                      style: GoogleFonts.cinzel(fontSize: 22, color: Colors.cyan, letterSpacing: 2,
                          shadows: const [Shadow(color: Colors.cyan, blurRadius: 10)])),
                  const SizedBox(height: 10),
                  TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.cyan,
                    indicatorWeight: 2,
                    labelColor: Colors.cyan,
                    unselectedLabelColor: Colors.white38,
                    labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    tabs: const [
                      Tab(text: '❤️ Favorites'),
                      Tab(text: '🍋 Ingredients'),
                      Tab(text: '📖 Journey'),
                    ],
                  ),
                ]),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _FavoritesTab(onOpenPage: _openPage),
                    _IngredientsTab(),
                    _JourneyTab(),
                  ],
                ),
              ),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Column(children: [
      Container(height: 1, decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Colors.transparent, Colors.cyan, Color(0xFF9000ff), Colors.cyan, Colors.transparent]),
      )),
      const SizedBox(height: 6),
      Wrap(spacing: 2, children: [
        _footerLink('About', () => _openPage(const AboutPage())),
        _footerLink('Privacy', () => _openPage(const PrivacyPage())),
        _footerLink('Legal', () => _openPage(const LegalPage())),
        _footerLink('Contact', () => _openPage(const ContactPage())),
        _footerLink('Refunds', () => _openPage(const RefundsPage())),
        _footerLink('Feedback', () => _openPage(const FeedbackPage())),
      ]),
      const SizedBox(height: 4),
      const Text('Drink responsibly. 21+ only.', style: TextStyle(color: Colors.white38, fontSize: 11)),
      const SizedBox(height: 8),
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
// FAVORITES TAB
// ═══════════════════════════════════════════════════════════════════════════

class _FavoritesTab extends StatefulWidget {
  final Function(Widget) onOpenPage;
  const _FavoritesTab({required this.onOpenPage});

  @override
  State<_FavoritesTab> createState() => _FavoritesTabState();
}

class _FavoritesTabState extends State<_FavoritesTab> {
  final _db = CocktailDbService();
  List<Map<String, dynamic>> _drinks = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() => _loading = true);
    final ids = await StorageService.getFavorites();
    final drinks = await Future.wait(ids.map((id) => _db.lookupById(id)));
    setState(() {
      _drinks = drinks.whereType<Map<String, dynamic>>().toList();
      _loading = false;
    });
  }

  Future<void> _removeFavorite(String id) async {
    await StorageService.toggleFavorite(id);
    _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator(color: Colors.cyan));

    if (_drinks.isEmpty) {
      return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text('🤍', style: TextStyle(fontSize: 60)),
        const SizedBox(height: 16),
        Text('No favorites yet', style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 16)),
        const SizedBox(height: 8),
        Text('Heart a drink to save it here', style: TextStyle(color: Colors.white.withValues(alpha: 0.3), fontSize: 13)),
      ]));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _drinks.length,
      itemBuilder: (_, i) {
        final drink = _drinks[i];
        final id = drink['idDrink'] as String;
        return GestureDetector(
          onTap: () => widget.onOpenPage(DrinkDetailScreen(drinkId: id)),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.cyan.withValues(alpha: 0.3)),
              color: Colors.cyan.withValues(alpha: 0.05),
            ),
            child: Row(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(drink['strDrinkThumb'] ?? '',
                    width: 65, height: 65, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(width: 65, height: 65,
                        color: const Color(0xFF1a0033),
                        child: const Center(child: Text('🍸', style: TextStyle(fontSize: 24))))),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(drink['strDrink'] ?? '',
                    style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                if (drink['strCategory'] != null) ...[
                  const SizedBox(height: 4),
                  Text(drink['strCategory'],
                      style: TextStyle(color: Colors.cyan.withValues(alpha: 0.7), fontSize: 12)),
                ],
                
              ])),
              GestureDetector(
                onTap: () => _removeFavorite(id),
                child: const Padding(padding: EdgeInsets.all(8),
                    child: Text('❤️', style: TextStyle(fontSize: 20))),
              ),
            ]),
          ),
        );
      },
    );
  }
}



// ═══════════════════════════════════════════════════════════════════════════
// INGREDIENTS TAB
// ═══════════════════════════════════════════════════════════════════════════

class _IngredientsTab extends StatefulWidget {
  @override
  State<_IngredientsTab> createState() => _IngredientsTabState();
}

class _IngredientsTabState extends State<_IngredientsTab> {
  List<String> _ingredients = [];
  bool _loading = true;
  final TextEditingController _addController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _addController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final ings = await StorageService.getIngredients();
    setState(() { _ingredients = ings; _loading = false; });
  }

  Future<void> _addIngredient(String name) async {
    if (name.trim().isEmpty) return;
    await StorageService.addIngredients([name.trim()]);
    _addController.clear();
    _load();
  }

  Future<void> _remove(String ingredient) async {
    await StorageService.removeIngredient(ingredient);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator(color: Colors.cyan));

    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(16),
        child: Row(children: [
          Expanded(
            child: TextField(
              controller: _addController,
              style: const TextStyle(color: Colors.cyan, fontSize: 13),
              onSubmitted: _addIngredient,
              decoration: InputDecoration(
                hintText: 'Add ingredient...',
                hintStyle: const TextStyle(color: Colors.white38, fontSize: 12),
                filled: true, fillColor: const Color(0xFF1a0040), isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Colors.cyan)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Colors.cyan)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Colors.cyan, width: 2)),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => _addIngredient(_addController.text),
            child: Container(
              width: 42, height: 42,
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.cyan.withValues(alpha: 0.15), border: Border.all(color: Colors.cyan)),
              child: const Icon(Icons.add, color: Colors.cyan, size: 20),
            ),
          ),
        ]),
      ),
      if (_ingredients.isEmpty)
        Expanded(child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('🍋', style: TextStyle(fontSize: 60)),
          const SizedBox(height: 16),
          Text('No ingredients yet', style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 16)),
          const SizedBox(height: 8),
          Text('Scan your bar or add manually', style: TextStyle(color: Colors.white.withValues(alpha: 0.3), fontSize: 13)),
        ])))
      else
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            itemCount: _ingredients.length,
            itemBuilder: (_, i) {
              final ing = _ingredients[i];
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.cyan.withValues(alpha: 0.25)),
                  color: Colors.cyan.withValues(alpha: 0.04),
                ),
                child: Row(children: [
                  const Text('🍋', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 12),
                  Expanded(child: Text(ing, style: const TextStyle(color: Colors.white, fontSize: 14))),
                  GestureDetector(
                    onTap: () => _remove(ing),
                    child: Icon(Icons.close, color: Colors.white.withValues(alpha: 0.3), size: 18),
                  ),
                ]),
              );
            },
          ),
        ),
    ]);
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// JOURNEY TAB
// ═══════════════════════════════════════════════════════════════════════════

class _JourneyTab extends StatefulWidget {
  @override
  State<_JourneyTab> createState() => _JourneyTabState();
}

class _JourneyTabState extends State<_JourneyTab> {
  List<Map<String, dynamic>> _entries = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final entries = await StorageService.getJourney();
    setState(() { _entries = entries; _loading = false; });
  }

  Future<void> _delete(String id) async {
    await StorageService.deleteJourneyEntry(id);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator(color: Colors.cyan));

    if (_entries.isEmpty) {
      return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text('📖', style: TextStyle(fontSize: 60)),
        const SizedBox(height: 16),
        Text('No journey entries yet', style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 16)),
        const SizedBox(height: 8),
        Text('Your Genie sessions will appear here', style: TextStyle(color: Colors.white.withValues(alpha: 0.3), fontSize: 13)),
      ]));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _entries.length,
      itemBuilder: (_, i) {
        final entry = _entries[i];
        final date = entry['date'] as String? ?? '';
        final bottles = List<String>.from(entry['bottles'] as List? ?? []);
        final ingredients = List<String>.from(entry['ingredients'] as List? ?? []);
        final description = entry['description'] as String? ?? '';
        final id = entry['id'] as String? ?? '';

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFCC88FF).withValues(alpha: 0.3)),
            color: const Color(0xFFCC88FF).withValues(alpha: 0.04),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(date, style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 11)),
              const Spacer(),
              GestureDetector(
                onTap: () => _delete(id),
                child: Icon(Icons.delete_outline, color: Colors.white.withValues(alpha: 0.3), size: 18),
              ),
            ]),
            const SizedBox(height: 8),
            if (description.isNotEmpty) ...[
              Text(description,
                  style: GoogleFonts.playfairDisplay(color: const Color(0xFFd4af37), fontSize: 13, fontStyle: FontStyle.italic),
                  maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 8),
            ],
            if (bottles.isNotEmpty) ...[
              Wrap(spacing: 6, runSpacing: 4, children: bottles.map((b) => _chip(b, Colors.cyan)).toList()),
              const SizedBox(height: 4),
            ],
            if (ingredients.isNotEmpty)
              Wrap(spacing: 6, runSpacing: 4, children: ingredients.map((i) => _chip(i, const Color(0xFFCC88FF))).toList()),
          ]),
        );
      },
    );
  }

  Widget _chip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.4)),
        color: color.withValues(alpha: 0.08),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 11)),
    );
  }
}