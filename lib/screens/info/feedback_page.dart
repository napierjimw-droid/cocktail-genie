import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:html' as html;

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  String _selectedType = 'General Feedback';
  bool _sent = false;

  final List<String> _feedbackTypes = [
    'General Feedback',
    'Bug Report',
    'Feature Request',
    'Drink Suggestion',
    'Other',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_messageController.text.trim().isEmpty) return;
    final name = _nameController.text.trim().isEmpty ? 'Anonymous' : _nameController.text.trim();
    final email = _emailController.text.trim();
    final message = _messageController.text.trim();
    final subject = Uri.encodeComponent('[$_selectedType] Cocktail Genie Feedback from $name');
    final body = Uri.encodeComponent(
      'Name: $name\nEmail: ${email.isEmpty ? 'Not provided' : email}\nType: $_selectedType\n\nMessage:\n$message\n\n---\nSent from Cocktail Genie App',
    );
    html.window.open('mailto:genieversellc@gmail.com?subject=$subject&body=$body', '_self');
    setState(() => _sent = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(center: Alignment.topCenter, radius: 1.8,
              colors: [Color(0xFF2d0060), Color(0xFF0d0030)]),
        ),
        child: SafeArea(
          child: Column(children: [
            // Header
            Container(
              height: 58,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF1a0040),
                border: const Border(bottom: BorderSide(color: Colors.cyan, width: 1.5)),
                boxShadow: [BoxShadow(color: Colors.cyan.withValues(alpha: 0.2), blurRadius: 14)],
              ),
              child: Row(children: [
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
                Expanded(child: Text('💬 Feedback',
                    style: GoogleFonts.cinzel(fontSize: 18, color: Colors.cyan, letterSpacing: 1.5,
                        shadows: const [Shadow(color: Colors.cyan, blurRadius: 8)]))),
              ]),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: _sent ? _buildThankYou() : _buildForm(),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Genie intro
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFd4af37).withValues(alpha: 0.4)),
          color: const Color(0xFFd4af37).withValues(alpha: 0.06),
        ),
        child: Row(children: [
          const Text('🧞', style: TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(child: Text(
            'Your wishes help me grow wiser. Share your thoughts with GenieVerse!',
            style: GoogleFonts.playfairDisplay(color: const Color(0xFFd4af37), fontSize: 14, fontStyle: FontStyle.italic),
          )),
        ]),
      ),
      const SizedBox(height: 24),

      // Type selector
      Text('Type', style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12, letterSpacing: 1)),
      const SizedBox(height: 8),
      Wrap(spacing: 8, runSpacing: 8, children: _feedbackTypes.map((type) {
        final selected = type == _selectedType;
        return GestureDetector(
          onTap: () => setState(() => _selectedType = type),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: selected ? Colors.cyan : Colors.white24),
              color: selected ? Colors.cyan.withValues(alpha: 0.15) : Colors.transparent,
            ),
            child: Text(type, style: TextStyle(color: selected ? Colors.cyan : Colors.white54, fontSize: 12)),
          ),
        );
      }).toList()),
      const SizedBox(height: 20),

      // Name
      Text('Name (optional)', style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12, letterSpacing: 1)),
      const SizedBox(height: 8),
      _inputField(_nameController, 'Your name...'),
      const SizedBox(height: 16),

      // Email
      Text('Email (optional)', style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12, letterSpacing: 1)),
      const SizedBox(height: 8),
      _inputField(_emailController, 'your@email.com', keyboardType: TextInputType.emailAddress),
      const SizedBox(height: 16),

      // Message
      Text('Message *', style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12, letterSpacing: 1)),
      const SizedBox(height: 8),
      _inputField(_messageController, 'Tell us what you think...', maxLines: 5),
      const SizedBox(height: 24),

      // Submit
      GestureDetector(
        onTap: _submit,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.cyan.withValues(alpha: 0.8)),
            color: Colors.cyan.withValues(alpha: 0.12),
            boxShadow: [BoxShadow(color: Colors.cyan.withValues(alpha: 0.25), blurRadius: 16)],
          ),
          child: Text('✨ Send to GenieVerse',
              textAlign: TextAlign.center,
              style: GoogleFonts.cinzel(color: Colors.cyan, fontSize: 15, letterSpacing: 1)),
        ),
      ),
      const SizedBox(height: 12),
      Text('Opens your email app to send to genieversellc@gmail.com',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white.withValues(alpha: 0.3), fontSize: 11)),
    ]);
  }

  Widget _inputField(TextEditingController controller, String hint,
      {int maxLines = 1, TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3), fontSize: 13),
        filled: true, fillColor: const Color(0xFF1a0040), isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.cyan.withValues(alpha: 0.3))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.cyan.withValues(alpha: 0.3))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.cyan, width: 1.5)),
      ),
    );
  }

  Widget _buildThankYou() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const SizedBox(height: 60),
      const Text('🧞', style: TextStyle(fontSize: 80)),
      const SizedBox(height: 24),
      Text('Wish received!',
          style: GoogleFonts.cinzel(color: Colors.cyan, fontSize: 24, letterSpacing: 2,
              shadows: const [Shadow(color: Colors.cyan, blurRadius: 12)])),
      const SizedBox(height: 16),
      Text(
        'Your email app should have opened.\nThank you for helping GenieVerse grow!',
        textAlign: TextAlign.center,
        style: GoogleFonts.playfairDisplay(
            color: const Color(0xFFd4af37), fontSize: 15, fontStyle: FontStyle.italic, height: 1.6),
      ),
      const SizedBox(height: 40),
      GestureDetector(
        onTap: () => setState(() {
          _sent = false;
          _nameController.clear();
          _emailController.clear();
          _messageController.clear();
        }),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Colors.cyan.withValues(alpha: 0.5)),
          ),
          child: const Text('Send another', style: TextStyle(color: Colors.cyan)),
        ),
      ),
    ]);
  }
}