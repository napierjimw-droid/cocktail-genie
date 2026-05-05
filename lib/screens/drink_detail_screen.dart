import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../services/cocktail_db_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:html' as html;
import '../services/storage_service.dart';

const List<String> kGenieLines = [
  "A timeless potion… handle with care.",
  "I sense citrus magic in this one.",
  "Perfect choice for a midnight toast.",
  "Even spirits would envy this mix.",
  "Stir gently… destiny is fragile.",
];

class DrinkDetailScreen extends StatefulWidget {
  final String drinkId;
  const DrinkDetailScreen({super.key, required this.drinkId});

  @override
  State<DrinkDetailScreen> createState() => _DrinkDetailScreenState();
}

class _DrinkDetailScreenState extends State<DrinkDetailScreen> {
  final _db = CocktailDbService();
  Map<String, dynamic>? _drink;
  bool _loading = true;
  bool _isFav = false;
  String _genieLine = '';

  @override
  void initState() {
    super.initState();
    _genieLine = kGenieLines[Random().nextInt(kGenieLines.length)];
    _loadDrink();
    StorageService.isFavorite(widget.drinkId).then((v) {
      if (mounted) setState(() => _isFav = v);
    });
  }

  Future<void> _loadDrink() async {
    final drink = await _db.lookupById(widget.drinkId);
    setState(() {
      _drink = drink;
      _loading = false;
    });
  }

  void _openMap(String drinkName) {
    final query = Uri.encodeComponent('bars serving $drinkName near me');
    final url = 'https://www.google.com/maps/search/$query';
    // Launch URL
    _launchUrl(url);
  }

  void _launchUrl(String url) {
    // Use js interop for web
    // ignore: undefined_prefixed_name
    try {
      // For web — open in new tab
      final anchor = Uri.parse(url);
      if (anchor.hasScheme) {
        // dart:html not available in all platforms, use workaround
        _openInBrowser(url);
      }
    } catch (e) {
      debugPrint('Could not launch $url: $e');
    }
  }

  void _openInBrowser(String url) {
     html.window.open(url, '_blank');
  }

  @override
  Widget build(BuildContext context) {
    final t = context.watch<LanguageProvider>().t;

    if (_loading) {
      return Scaffold(
        backgroundColor: const Color(0xFF050010),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: Colors.cyan),
              const SizedBox(height: 20),
              Text(t('loading_recipe'),
                  style: const TextStyle(color: Colors.cyan)),
            ],
          ),
        ),
      );
    }

    if (_drink == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF050010),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🧞', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 16),
              Text(t('no_results'),
                  style: const TextStyle(color: Colors.cyan),
                  textAlign: TextAlign.center),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back',
                    style: TextStyle(color: Colors.cyan)),
              ),
            ],
          ),
        ),
      );
    }

    final drink = _drink!;
    final ingredients = CocktailDbService.extractIngredients(drink);
    final drinkName = drink['strDrink'] ?? '';

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.5,
            colors: [Color(0xFF1a0033), Color(0xFF050010)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // ── Back button ──────────────────────────────────
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: Colors.cyan),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.arrow_back,
                                color: Colors.cyan, size: 16),
                            SizedBox(width: 6),
                            Text('Back',
                                style: TextStyle(color: Colors.cyan)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // ── Drink name ───────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    drinkName,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [Shadow(color: Colors.cyan, blurRadius: 10)],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),

                // ── Image ────────────────────────────────────────
                Stack(
                  children: [
                    Container(
                      width: 320,
                      height: 320,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                            color: Colors.cyan.withValues(alpha: 0.35)),
                        boxShadow: [BoxShadow(
                          color: Colors.cyan.withValues(alpha: 0.5),
                          blurRadius: 80,
                        )],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: Image.network(
                          drink['strDrinkThumb'] ?? '',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Center(
                              child: Text('🍸',
                                  style: TextStyle(fontSize: 80))),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 14,
                      top: 14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          drink['strAlcoholic'] == 'Alcoholic'
                              ? t('alcoholic')
                              : t('non_alcoholic'),
                          style: const TextStyle(
                              fontSize: 13, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // ── Meta badges ──────────────────────────────────
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: Colors.cyan.withValues(alpha: 0.4)),
                    color: Colors.cyan.withValues(alpha: 0.08),
                    boxShadow: [BoxShadow(
                      color: Colors.cyan.withValues(alpha: 0.2),
                      blurRadius: 30,
                    )],
                  ),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _metaBadge('🍸 ${drink['strCategory'] ?? ''}',
                          Colors.cyan.withValues(alpha: 0.15),
                          Colors.cyan.withValues(alpha: 0.4)),
                      _metaBadge('🥂 ${drink['strGlass'] ?? ''}',
                          Colors.white.withValues(alpha: 0.08),
                          Colors.white.withValues(alpha: 0.2)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // ── Favourite + Where to Find ────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Favourite
                    GestureDetector(
                      onTap: () async {
                        await StorageService.toggleFavorite(widget.drinkId);
                        setState(() => _isFav = !_isFav);
                      },
                      
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(_isFav ? '❤️' : '🤍',
                                style: const TextStyle(fontSize: 20)),
                            const SizedBox(width: 6),
                            Text(
                              _isFav ? 'Saved' : 'Save',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Where to Find
                    GestureDetector(
                      onTap: () => _openMap(drinkName),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                              color: const Color(0xFFd4af37)
                                  .withValues(alpha: 0.7)),
                          color: const Color(0xFFd4af37)
                              .withValues(alpha: 0.08),
                          boxShadow: [BoxShadow(
                            color: const Color(0xFFd4af37)
                                .withValues(alpha: 0.2),
                            blurRadius: 8,
                          )],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('📍', style: TextStyle(fontSize: 16)),
                            SizedBox(width: 6),
                            Text(
                              'Where to Find',
                              style: TextStyle(
                                color: Color(0xFFd4af37),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ── Genie quote ──────────────────────────────────
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF120033),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(
                      color: Colors.cyan.withValues(alpha: 0.3),
                      blurRadius: 20,
                    )],
                  ),
                  child: Text(
                    '🧞‍♂️ $_genieLine',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // ── Ingredients ──────────────────────────────────
                _buildSection(
                  title: '🍸 ${t('ingredients')}',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: ingredients.map((ing) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.circle,
                              color: Colors.cyan, size: 6),
                          const SizedBox(width: 10),
                          Expanded(child: Text(ing,
                              style: const TextStyle(color: Colors.white70))),
                        ],
                      ),
                    )).toList(),
                  ),
                ),
                const SizedBox(height: 16),

                // ── Instructions ─────────────────────────────────
                _buildSection(
                  title: '📜 ${t('instructions')}',
                  child: Text(
                    drink['strInstructions'] ?? '',
                    style: const TextStyle(color: Colors.white70, height: 1.6),
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.cyan.withValues(alpha: 0.35)),
        color: Colors.cyan.withValues(alpha: 0.06),
        boxShadow: [BoxShadow(
          color: Colors.cyan.withValues(alpha: 0.15),
          blurRadius: 30,
        )],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _metaBadge(String text, Color bg, Color border) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: bg,
        border: Border.all(color: border),
      ),
      child: Text(text,
          style: const TextStyle(fontSize: 13, color: Colors.white)),
    );
  }
}