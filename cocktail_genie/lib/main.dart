import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

void main() {
  runApp(const CocktailGenieApp());
}

class CocktailGenieApp extends StatelessWidget {
  const CocktailGenieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cocktail Genie',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF050010),
      ),
      home: const HomePage(),
    );
  }
}

const List<Map<String, String>> kCategories = [
  {"id": "sour", "label": "🍋 Sours"},
  {"id": "spirit", "label": "🥃 Spirit Forward"},
  {"id": "refreshing", "label": "🧊 Refreshing"},
  {"id": "tiki", "label": "🍹 Tropical / Tiki"},
  {"id": "dessert", "label": "🍬 Sweet / Dessert"},
  {"id": "sparkling", "label": "🍾 Sparkling"},
  {"id": "herbal", "label": "🌿 Herbal"},
  {"id": "strong", "label": "🔥 Strong"},
  {"id": "frozen", "label": "❄️ Frozen"},
  {"id": "genie", "label": "🧪 Experimental"},
];

const List<String> kGenieLines = [
  "A timeless potion… handle with care.",
  "I sense citrus magic in this one.",
  "Perfect choice for a midnight toast.",
  "Even spirits would envy this mix.",
  "Stir gently… destiny is fragile.",
];

// ─── SIMPLE PAGE TEMPLATE ──────────────────────────────────────────────────────

class SimpleInfoPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> children;

  const SimpleInfoPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // BACK
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: Colors.cyan),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.arrow_back, color: Colors.cyan, size: 16),
                          SizedBox(width: 6),
                          Text('Back', style: TextStyle(color: Colors.cyan)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // TITLE
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.cyan,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(color: Colors.cyan, blurRadius: 10)],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                // SUBTITLE
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFFd4af37),
                    fontStyle: FontStyle.italic,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ...children,
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _infoText(String text) => Padding(
  padding: const EdgeInsets.only(bottom: 16),
  child: Text(
    text,
    style: const TextStyle(color: Color(0xFFe0f7ff), fontSize: 15, height: 1.6),
    textAlign: TextAlign.center,
  ),
);

Widget _infoBox(String text) => Container(
  margin: const EdgeInsets.only(top: 16),
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: Colors.cyan.withOpacity(0.3)),
    color: Colors.cyan.withOpacity(0.05),
  ),
  child: Text(
    text,
    style: const TextStyle(color: Color(0xFF7df9ff), fontSize: 13),
    textAlign: TextAlign.center,
  ),
);

// ─── ABOUT PAGE ────────────────────────────────────────────────────────────────

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleInfoPage(
      title: '🧞 About the Genie',
      subtitle: '"Not all wishes come true… but cocktails usually do."',
      children: [
        _infoText('Brought to you by GenieVerse LLC—mixing magic and cocktails across all realms. Your wishes (and drinks) granted with a wink!'),
        _infoText('Cocktail Genie is your magical companion for discovering drinks from every corner of the world. Whether you crave a classic, something exotic, or a surprise you didn\'t know you needed — the genie is always ready to serve.'),
        _infoText('This app was built for explorers, curious minds, and anyone who believes that the perfect cocktail is just one wish away.'),
        _infoText('Browse, search, save favorites, and let a little chaos guide your next drink. After all… the best discoveries are often accidental.'),
        _infoBox('Powered by TheCocktailDB API 🍸\n(and a slightly mischievous genie)'),
      ],
    );
  }
}

// ─── PRIVACY PAGE ──────────────────────────────────────────────────────────────

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleInfoPage(
      title: '🔐 Privacy Policy',
      subtitle: '"Your secrets are safe… even from the genie."',
      children: [
        _infoText('We respect your privacy. Cocktail Genie does not collect personal information unless you voluntarily provide it (for example, via contact).'),
        _infoText('We do not sell, trade, or magically teleport your data to third parties. What happens in the app… stays in the app.'),
        _infoText('Some non-personal data (like usage patterns) may be collected to improve the experience — think of it as the genie learning your taste.'),
        _infoBox('Third-party services (like TheCocktailDB API) may operate under their own privacy policies.'),
        _infoText('By using this app, you agree to this policy. Laws vary by country — follow your local regulations.'),
      ],
    );
  }
}

// ─── LEGAL PAGE ────────────────────────────────────────────────────────────────

class LegalPage extends StatelessWidget {
  const LegalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleInfoPage(
      title: '⚖️ Legal Notice',
      subtitle: '"The genie grants wishes… not liability."',
      children: [
        _infoText('Cocktail Genie provides cocktail recipes and suggestions for informational and entertainment purposes only.'),
        _infoText('We do not guarantee accuracy, completeness, or that your drink will turn out Instagram-worthy.'),
        _infoText('Consumption of alcohol is your responsibility. Please drink responsibly and follow all local laws and regulations.'),
        _infoText('Cocktail Genie, GenieVerse LLC, and any associated magical entities are not liable for:'),
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              '🍸 Poor cocktail decisions',
              '🥴 Hangovers',
              '💬 Questionable late-night messages',
              '🕺 Unexpected dance confidence',
            ].map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(item, style: const TextStyle(color: Color(0xFFe0f7ff), fontSize: 15)),
            )).toList(),
          ),
        ),
        _infoBox('Data is provided by TheCocktailDB API. Please support them if you enjoy the service.'),
        _infoText('By using this app, you agree to these terms.'),
      ],
    );
  }
}

// ─── CONTACT PAGE ──────────────────────────────────────────────────────────────

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final TextEditingController _msgController = TextEditingController();
  bool _sent = false;

  @override
  Widget build(BuildContext context) {
    return SimpleInfoPage(
      title: '📬 Contact the Genie',
      subtitle: '"Whispers travel fast… but messages work better."',
      children: [
        _infoText('Found a bug? Have an idea? Want to praise the genie?'),
        if (!_sent) ...[
          const SizedBox(height: 12),
          TextField(
            controller: _msgController,
            style: const TextStyle(color: Colors.cyan),
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Your message...',
              hintStyle: const TextStyle(color: Colors.white38),
              filled: true,
              fillColor: const Color(0xFF111111),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.cyan),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.cyan),
              ),
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => setState(() => _sent = true),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.cyan,
              ),
              child: const Text(
                'Send Message ✨',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ] else
          _infoBox('🧞 Message received! The genie will respond soon.'),
        const SizedBox(height: 16),
        _infoText('Or email us directly: genieverse.contact@gmail.com'),
      ],
    );
  }
}

// ─── REFUNDS PAGE ──────────────────────────────────────────────────────────────

class RefundsPage extends StatelessWidget {
  const RefundsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleInfoPage(
      title: '💸 Refund Policy',
      subtitle: '"Wishes, once granted, cannot be taken back."',
      children: [
        _infoText('Cocktail Genie provides digital experiences and content instantly. Because of this, all interactions are considered fulfilled immediately.'),
        _infoText('As a result, refunds are generally not available once the service has been used.'),
        _infoText('However, if something is broken or not working correctly, please contact us — we will fix the issue as quickly as possible.'),
        _infoBox('This policy applies globally. Local consumer protection laws may override certain conditions.'),
        _infoText('GenieVerse LLC reserves the right to update this policy at any time.'),
      ],
    );
  }
}

// ─── FEEDBACK PAGE ─────────────────────────────────────────────────────────────

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleInfoPage(
      title: '💬 Feedback',
      subtitle: '"The genie is still learning your taste."',
      children: [
        _infoText('Feedback portal coming soon.'),
        _infoText('Genie is still learning your taste.'),
        _infoBox('In the meantime, reach us at:\ngenieverse.contact@gmail.com'),
      ],
    );
  }
}

// ─── DETAIL PAGE ───────────────────────────────────────────────────────────────

class DrinkDetailPage extends StatefulWidget {
  final String drinkId;
  const DrinkDetailPage({super.key, required this.drinkId});

  @override
  State<DrinkDetailPage> createState() => _DrinkDetailPageState();
}

class _DrinkDetailPageState extends State<DrinkDetailPage> {
  Map<String, dynamic>? _drink;
  bool _loading = true;
  bool _isFav = false;
  int _stars = 0;
  String _genieLine = '';

  @override
  void initState() {
    super.initState();
    _genieLine = kGenieLines[Random().nextInt(kGenieLines.length)];
    _loadDrink();
  }

  Future<void> _loadDrink() async {
    final res = await http.get(Uri.parse(
        'https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=${widget.drinkId}'));
    final data = jsonDecode(res.body);
    setState(() {
      _drink = data['drinks']?[0];
      _loading = false;
    });
  }

  List<String> _getIngredients() {
    final list = <String>[];
    for (int i = 1; i <= 15; i++) {
      final ing = _drink?['strIngredient$i'];
      final meas = _drink?['strMeasure$i'] ?? '';
      if (ing != null && ing.toString().isNotEmpty) {
        list.add('$meas $ing'.trim());
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: const Color(0xFF050010),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.cyan),
              SizedBox(height: 20),
              Text('Loading magical recipe...', style: TextStyle(color: Colors.cyan)),
            ],
          ),
        ),
      );
    }

    final drink = _drink!;
    final ingredients = _getIngredients();

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
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: Colors.cyan),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.arrow_back, color: Colors.cyan, size: 16),
                              SizedBox(width: 6),
                              Text('Back', style: TextStyle(color: Colors.cyan)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    drink['strDrink'] ?? '',
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white, shadows: [Shadow(color: Colors.cyan, blurRadius: 10)]),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                Stack(
                  children: [
                    Container(
                      width: 320,
                      height: 320,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: Colors.cyan.withOpacity(0.35)),
                        boxShadow: [
                          BoxShadow(color: Colors.cyan.withOpacity(0.65), blurRadius: 80),
                          BoxShadow(color: Colors.cyan.withOpacity(0.25), blurRadius: 140),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: Image.network(drink['strDrinkThumb'] ?? '', fit: BoxFit.cover),
                      ),
                    ),
                    Positioned(
                      left: 14,
                      top: 14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(999)),
                        child: Text(
                          drink['strAlcoholic'] == 'Alcoholic' ? '🍸 Alcoholic' : '🥤 Non-Alcoholic',
                          style: const TextStyle(fontSize: 13, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.cyan.withOpacity(0.4)),
                    color: Colors.cyan.withOpacity(0.08),
                    boxShadow: [BoxShadow(color: Colors.cyan.withOpacity(0.35), blurRadius: 40)],
                  ),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _metaBadge('🍸 ${drink['strCategory']}', Colors.cyan.withOpacity(0.15), Colors.cyan.withOpacity(0.4)),
                      _metaBadge('🥂 ${drink['strGlass']}', Colors.white.withOpacity(0.08), Colors.white.withOpacity(0.2)),
                      _metaBadge(
                        drink['strAlcoholic'] == 'Alcoholic' ? '🍷 Alcoholic' : '🥤 Non-Alcoholic',
                        const Color(0xFF661428).withOpacity(0.12),
                        const Color(0xFFff6496).withOpacity(0.35),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => _isFav = !_isFav),
                      child: Text(_isFav ? '❤️' : '🤍', style: const TextStyle(fontSize: 28)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF120033),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.cyan.withOpacity(0.3), blurRadius: 20)],
                  ),
                  child: Text('🧞‍♂️ $_genieLine', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontStyle: FontStyle.italic)),
                ),
                const SizedBox(height: 24),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.cyan.withOpacity(0.35)),
                    color: Colors.cyan.withOpacity(0.06),
                    boxShadow: [BoxShadow(color: Colors.cyan.withOpacity(0.25), blurRadius: 30)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('🍸 Ingredients', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 12),
                      ...ingredients.map((ing) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            const Icon(Icons.circle, color: Colors.cyan, size: 6),
                            const SizedBox(width: 10),
                            Text(ing, style: const TextStyle(color: Colors.white70)),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.cyan.withOpacity(0.35)),
                    color: Colors.cyan.withOpacity(0.06),
                    boxShadow: [BoxShadow(color: Colors.cyan.withOpacity(0.25), blurRadius: 30)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('📜 Instructions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 12),
                      Text(drink['strInstructions'] ?? '', style: const TextStyle(color: Colors.white70, height: 1.6)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.cyan.withOpacity(0.5)),
                    color: Colors.cyan.withOpacity(0.08),
                    boxShadow: [BoxShadow(color: Colors.cyan.withOpacity(0.5), blurRadius: 60)],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: List.generate(5, (i) {
                          final n = i + 1;
                          return GestureDetector(
                            onTap: () => setState(() => _stars = _stars == n ? 0 : n),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: Text('⭐', style: TextStyle(fontSize: 22, color: n <= _stars ? Colors.amber : Colors.white24)),
                            ),
                          );
                        }),
                      ),
                      const Text('🔗', style: TextStyle(fontSize: 22)),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _metaBadge(String text, Color bg, Color border) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(999), color: bg, border: Border.all(color: border)),
      child: Text(text, style: const TextStyle(fontSize: 13, color: Colors.white)),
    );
  }
}

// ─── HOME PAGE ─────────────────────────────────────────────────────────────────

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  bool _categoriesOpen = false;
  bool _langOpen = false;
  String _selectedLanguage = 'EN';
  String? _selectedCategory;
  List<dynamic> _searchResults = [];
  List<dynamic> _suggestions = [];
  bool _loading = false;
  bool _showSuggestions = false;

  final List<String> _languages = ['EN', 'ES', 'DE', 'FR', 'IT', 'PT', 'RU', 'JP'];

  Future<void> _onSearchChanged(String value) async {
    if (value.length < 2) {
      setState(() { _suggestions = []; _showSuggestions = false; });
      return;
    }
    final res = await http.get(Uri.parse('https://www.thecocktaildb.com/api/json/v1/1/search.php?s=$value'));
    final data = jsonDecode(res.body);
    setState(() {
      _suggestions = (data['drinks'] ?? []).take(6).toList();
      _showSuggestions = true;
    });
  }

  Future<void> _search(String query) async {
    if (query.isEmpty) return;
    setState(() { _loading = true; _showSuggestions = false; });
    final res = await http.get(Uri.parse('https://www.thecocktaildb.com/api/json/v1/1/search.php?s=$query'));
    final data = jsonDecode(res.body);
    setState(() {
      _searchResults = data['drinks'] ?? [];
      _loading = false;
    });
  }

  void _openDrink(String id) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => DrinkDetailPage(drinkId: id)));
  }

  void _openPage(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() { _langOpen = false; _showSuggestions = false; }),
      child: Scaffold(
        body: Stack(
          children: [
            Container(
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
                      // TOP BAR
                      Container(
                        height: 64,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFF2a0050), Color(0xFF0d0030), Color(0xFF050014)],
                          ),
                          border: const Border(bottom: BorderSide(color: Colors.cyan, width: 1.5)),
                          boxShadow: [
                            BoxShadow(color: Colors.cyan.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 4)),
                            BoxShadow(color: const Color(0xFF9000ff).withOpacity(0.2), blurRadius: 30, offset: const Offset(0, 2)),
                          ],
                        ),
                        child: Row(
                          children: [
                            // CATEGORIES
                            GestureDetector(
                              onTap: () => setState(() { _categoriesOpen = !_categoriesOpen; _langOpen = false; }),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(color: Colors.cyan),
                                  boxShadow: [BoxShadow(color: Colors.cyan.withOpacity(0.4), blurRadius: 8)],
                                ),
                                child: Text('🍹 ${_categoriesOpen ? "▲" : "▼"}', style: const TextStyle(color: Colors.white, fontSize: 14)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // SEARCH
                            Expanded(
                              child: Center(
                                child: SizedBox(
                                  width: 340,
                                  child: TextField(
                                    controller: _searchController,
                                    style: const TextStyle(color: Color(0xFF00ffff), fontSize: 14),
                                    onChanged: _onSearchChanged,
                                    onSubmitted: _search,
                                    decoration: InputDecoration(
                                      hintText: 'Search cocktails...',
                                      hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
                                      filled: true,
                                      fillColor: const Color(0xFF111111),
                                      isDense: true,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Colors.cyan)),
                                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Colors.cyan)),
                                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Colors.cyan, width: 2)),
                                      suffixIcon: IconButton(
                                        icon: const Icon(Icons.search, color: Colors.cyan, size: 18),
                                        onPressed: () => _search(_searchController.text),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // LANGUAGE
                            GestureDetector(
                              onTap: () => setState(() { _langOpen = !_langOpen; _categoriesOpen = false; }),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(color: Colors.cyan),
                                  boxShadow: [BoxShadow(color: Colors.cyan.withOpacity(0.4), blurRadius: 8)],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.language, color: Colors.cyan, size: 14),
                                    const SizedBox(width: 4),
                                    Text(_selectedLanguage, style: const TextStyle(color: Color(0xFF7df9ff), fontSize: 13)),
                                    const Icon(Icons.arrow_drop_down, color: Colors.cyan, size: 14),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // SIGN IN
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFF14003C).withOpacity(0.55),
                                  border: Border.all(color: Colors.cyan, width: 2),
                                  boxShadow: [BoxShadow(color: Colors.cyan.withOpacity(0.4), blurRadius: 8)],
                                ),
                                child: const Center(child: Text('👤', style: TextStyle(fontSize: 16))),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // CATEGORIES DROPDOWN
                      if (_categoriesOpen)
                        Container(
                          margin: const EdgeInsets.all(12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0d0225),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.cyan.withOpacity(0.25)),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.6), blurRadius: 40)],
                          ),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: kCategories.map((cat) {
                              final selected = _selectedCategory == cat['id'];
                              return GestureDetector(
                                onTap: () => setState(() { _selectedCategory = cat['id']; _categoriesOpen = false; }),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(color: Colors.cyan),
                                    color: selected ? Colors.cyan.withOpacity(0.2) : Colors.transparent,
                                  ),
                                  child: Text(cat['label']!, style: const TextStyle(color: Colors.white)),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      // AUTOCOMPLETE
                      if (_showSuggestions && _suggestions.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 80),
                          decoration: BoxDecoration(
                            color: const Color(0xFF14003C).withOpacity(0.95),
                            border: Border.all(color: Colors.cyan.withOpacity(0.4)),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [BoxShadow(color: Colors.cyan.withOpacity(0.2), blurRadius: 10)],
                          ),
                          child: Column(
                            children: _suggestions.map((drink) {
                              return GestureDetector(
                                onTap: () {
                                  _searchController.text = drink['strDrink'];
                                  _search(drink['strDrink']);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white12))),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: Image.network(drink['strDrinkThumb'], width: 40, height: 40, fit: BoxFit.cover),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(drink['strDrink'], style: const TextStyle(color: Colors.cyan)),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      const SizedBox(height: 30),
                      // TITLE
                      const Text(
                        'Cocktail Genie',
                        style: TextStyle(
                          color: Colors.cyan,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          shadows: [Shadow(color: Colors.cyan, blurRadius: 20), Shadow(color: Colors.cyan, blurRadius: 40)],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Image.asset('assets/images/genie.png', height: 260),
                      const SizedBox(height: 12),
                      const Text(
                        'From desert winds to crystal glass...',
                        style: TextStyle(color: Colors.amber, fontStyle: FontStyle.italic, fontSize: 14),
                      ),
                      const SizedBox(height: 40),
                      // SEARCH RESULTS
                      if (_loading)
                        const Padding(
                          padding: EdgeInsets.all(20),
                          child: CircularProgressIndicator(color: Colors.cyan),
                        )
                      else if (_searchResults.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: _searchResults.map((drink) {
                              return GestureDetector(
                                onTap: () => _openDrink(drink['idDrink']),
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: Colors.cyan.withOpacity(0.4)),
                                    color: Colors.white10,
                                  ),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(drink['strDrinkThumb'], width: 60, height: 60, fit: BoxFit.cover),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(child: Text(drink['strDrink'], style: const TextStyle(color: Colors.white, fontSize: 16))),
                                      const Icon(Icons.arrow_forward_ios, color: Colors.cyan, size: 16),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      const SizedBox(height: 40),
                      // GRADIENT DIVIDER
                      Container(
                        height: 1.5,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.transparent, Colors.cyan, Color(0xFF9000ff), Colors.cyan, Colors.transparent],
                          ),
                          boxShadow: [BoxShadow(color: Colors.cyan.withOpacity(0.4), blurRadius: 10)],
                        ),
                      ),
                      const SizedBox(height: 10),
                      // FOOTER LINKS
                      Wrap(
                        spacing: 20,
                        children: [
                          TextButton(onPressed: () => _openPage(const AboutPage()), child: const Text('About', style: TextStyle(color: Colors.cyan))),
                          TextButton(onPressed: () => _openPage(const PrivacyPage()), child: const Text('Privacy', style: TextStyle(color: Colors.cyan))),
                          TextButton(onPressed: () => _openPage(const LegalPage()), child: const Text('Legal', style: TextStyle(color: Colors.cyan))),
                          TextButton(onPressed: () => _openPage(const ContactPage()), child: const Text('Contact', style: TextStyle(color: Colors.cyan))),
                          TextButton(onPressed: () => _openPage(const RefundsPage()), child: const Text('Refunds', style: TextStyle(color: Colors.cyan))),
                          TextButton(onPressed: () => _openPage(const FeedbackPage()), child: const Text('Feedback', style: TextStyle(color: Colors.cyan))),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text('Drink responsibly. 21+ only.', style: TextStyle(color: Colors.white38, fontSize: 11)),
                      const SizedBox(height: 4),
                      const Text('© 2026 Cocktail Genie by GenieVerse LLC', style: TextStyle(color: Colors.white38, fontSize: 11)),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
            // LANGUAGE DROPDOWN OVERLAY
            if (_langOpen)
              Positioned(
                top: 70,
                right: 56,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF07001f),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.cyan),
                      boxShadow: [BoxShadow(color: Colors.cyan.withOpacity(0.4), blurRadius: 12)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _languages.map((lang) {
                        final selected = lang == _selectedLanguage;
                        return GestureDetector(
                          onTap: () => setState(() { _selectedLanguage = lang; _langOpen = false; }),
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 3),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(color: Colors.cyan),
                              color: selected ? Colors.cyan.withOpacity(0.2) : Colors.transparent,
                            ),
                            child: Text(lang, style: const TextStyle(color: Color(0xFF7df9ff))),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}