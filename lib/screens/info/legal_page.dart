import 'package:flutter/material.dart';
import 'simple_info_page.dart';

class LegalPage extends StatelessWidget {
  const LegalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimpleInfoPage(
      title: '⚖️ Legal Notice',
      subtitle: '"The genie grants wishes… not liability."',
      children: [
        InfoText('Cocktail Genie provides cocktail recipes and suggestions for informational and entertainment purposes only.'),
        InfoText('We do not guarantee accuracy, completeness, or that your drink will turn out Instagram-worthy.'),
        InfoText('Consumption of alcohol is your responsibility. Please drink responsibly and follow all local laws.'),
        InfoBox('Data is provided by TheCocktailDB API. Please support them if you enjoy the service.'),
        InfoText('By using this app, you agree to these terms.'),
      ],
    );
  }
}