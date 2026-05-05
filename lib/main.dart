import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/language_provider.dart';
import 'screens/home_screen.dart';
import 'screens/genie_camera_screen.dart';
import 'screens/my_bar_screen.dart';
import 'widgets/bottom_nav_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load saved language before app starts
  final langProvider = LanguageProvider();
  await langProvider.load();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: langProvider),
      ],
      child: const CocktailGenieApp(),
    ),
  );
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
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      home: const AppShell(),
    );
  }
}

// ── App shell — manages bottom nav + tab switching ──────────────────────────

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  // Keep screens alive when switching tabs
  final List<Widget> _screens = const [
    HomeScreen(),
    SizedBox.shrink(), // Genie tab — opens camera, not a screen
    MyBarScreen(),
  ];

  void _onNavTap(int index) {
    if (index == 1) {
      // Genie tab — push camera screen instead of switching tab
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, animation, __) => const GenieCameraScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            );
          },
        ),
      );
      return;
    }
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Page content ──────────────────────────────────────
          IndexedStack(
            index: _currentIndex == 2 ? 1 : 0,
            children: [_screens[0], _screens[2]],
          ),

          // ── Floating bottom nav ───────────────────────────────
          BottomNavBar(
            currentIndex: _currentIndex,
            onTap: _onNavTap,
          ),
        ],
      ),
    );
  }
}