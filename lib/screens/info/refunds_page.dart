import 'package:flutter/material.dart';
import 'simple_info_page.dart';

class RefundsPage extends StatelessWidget {
  const RefundsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimpleInfoPage(
      title: '💸 Refund Policy',
      subtitle: '"Wishes, once granted, cannot be taken back."',
      children: [
        InfoText('Cocktail Genie provides digital experiences and content instantly. Because of this, all interactions are considered fulfilled immediately.'),
        InfoText('As a result, refunds are generally not available once the service has been used.'),
        InfoText('However, if something is broken or not working correctly, please contact us — we will fix the issue as quickly as possible.'),
        InfoBox('This policy applies globally. Local consumer protection laws may override certain conditions.'),
        InfoText('GenieVerse LLC reserves the right to update this policy at any time.'),
      ],
    );
  }
}