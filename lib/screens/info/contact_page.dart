import 'package:flutter/material.dart';
import 'simple_info_page.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final TextEditingController _msgController = TextEditingController();
  bool _sent = false;

  @override
  void dispose() {
    _msgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleInfoPage(
      title: '📬 Contact the Genie',
      subtitle: '"Whispers travel fast… but messages work better."',
      children: [
        const InfoText('Found a bug? Have an idea? Want to praise the genie?'),
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
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ] else
          const InfoBox('🧞 Message received! The genie will respond soon.'),
        const SizedBox(height: 16),
        const InfoText('Or email us: genieversellc@gmail.com'),
      ],
    );
  }
}