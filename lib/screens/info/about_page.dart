import 'package:flutter/material.dart';
import 'simple_info_page.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimpleInfoPage(
      title: '🧞 About the Genie',
      subtitle: '"Not all wishes come true… but cocktails usually do."',
      children: [
        InfoText(
            'Brought to you by GenieVerse LLC — mixing magic and cocktails across all realms. Your wishes (and drinks) granted with a wink!'),
        InfoText(
            'Cocktail Genie is your magical companion for discovering drinks from every corner of the world. Whether you crave a classic, something exotic, or a surprise you didn\'t know you needed — the genie is always ready to serve.'),
        InfoText(
            'This app was built for explorers, curious minds, and anyone who believes that the perfect cocktail is just one wish away.'),
        InfoText(
            'Browse, search, save favorites, and let a little chaos guide your next drink. After all… the best discoveries are often accidental.'),
        InfoBox('Powered by TheCocktailDB API 🍸\n(and a slightly mischievous genie)'),
      ],
    );
  }
}