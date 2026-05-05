import 'package:flutter/material.dart';

// ─── Reusable info page template ──────────────────────────────────────────────

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
                // Back button
                Align(
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
                          Icon(Icons.arrow_back, color: Colors.cyan, size: 16),
                          SizedBox(width: 6),
                          Text('Back',
                              style: TextStyle(color: Colors.cyan)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Title
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

                // Subtitle
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

// ─── Helper widgets ───────────────────────────────────────────────────────────

class InfoText extends StatelessWidget {
  final String text;
  const InfoText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFFe0f7ff),
          fontSize: 15,
          height: 1.6,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class InfoBox extends StatelessWidget {
  final String text;
  const InfoBox(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.cyan.withValues(alpha: 0.3)),
        color: Colors.cyan.withValues(alpha: 0.05),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Color(0xFF7df9ff), fontSize: 13),
        textAlign: TextAlign.center,
      ),
    );
  }
}