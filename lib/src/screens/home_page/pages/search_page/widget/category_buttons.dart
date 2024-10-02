import 'package:amathia/src/screens/home_page/pages/search_page/widget/category_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CategoryButtons extends StatelessWidget {
  final String userId;
  const CategoryButtons({super.key, required this.userId,});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CategoryButton(
              userId: userId,
              colore: Colors.orangeAccent,
              text: localizations!.recipes,
              icon: Icons.restaurant,
              title: localizations.recipes,
              type: "Ricette",
            ),
            const SizedBox(
              width: 10,
            ),
            CategoryButton(
              userId: userId,
              colore: Colors.pinkAccent,
              text: localizations.monuments,
              icon: Icons.account_balance,
              title: localizations.monuments,
              type: 'Monumenti',
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CategoryButton(
              userId: userId,
              colore: Colors.greenAccent,
              text: localizations.nature,
              icon: Icons.energy_savings_leaf,
              title: localizations.nature,
              type: 'Natura',
            ),
            const SizedBox(
              width: 10,
            ),
            CategoryButton(
              userId: userId,
              colore: Colors.blueAccent,
              text: localizations.cities,
              icon: Icons.castle,
              title: localizations.cities,
              type: 'Borghi',
            ),
          ],
        ),
      ],
    );
  }
}
