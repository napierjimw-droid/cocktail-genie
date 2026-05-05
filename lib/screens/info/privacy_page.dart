import 'package:flutter/material.dart';
import 'simple_info_page.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimpleInfoPage(
      title: '🔐 Privacy Policy',
      subtitle: '"Your secrets are safe… even from the genie."',
      children: [
        InfoText('We respect your privacy. Cocktail Genie does not collect personal information unless you voluntarily provide it.'),
        InfoText('We do not sell, trade, or magically teleport your data to third parties. What happens in the app… stays in the app.'),
        InfoText('Some non-personal data (like usage patterns) may be collected to improve the experience — think of it as the genie learning your taste.'),
        InfoBox('Third-party services (like TheCocktailDB API) may operate under their own privacy policies.'),
        InfoText('By using this app, you agree to this policy. Laws vary by country — follow your local regulations.'),
      ],
    );
  }
}