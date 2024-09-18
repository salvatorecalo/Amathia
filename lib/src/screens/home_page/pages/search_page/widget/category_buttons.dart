import 'package:amathia/src/screens/home_page/pages/search_page/widget/category_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CategoryButtons extends StatelessWidget {
  const CategoryButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CategoryButton(
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
