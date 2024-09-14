import 'package:amathia/src/screens/home_page/pages/search_page/widget/category_button.dart';
import 'package:flutter/material.dart';

class CategoryButtons extends StatelessWidget {
  const CategoryButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CategoryButton(
              colore: Colors.orangeAccent,
              text: 'Ricette',
              icon: Icons.restaurant,
              title: 'Ricette',
              type: "Ricette",
            ),
            SizedBox(
              width: 10,
            ),
            CategoryButton(
              colore: Colors.pinkAccent,
              text: 'Monumenti',
              icon: Icons.account_balance,
              title: 'Monumenti',
              type: 'Monumenti',
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CategoryButton(
              colore: Colors.greenAccent,
              text: 'Natura',
              icon: Icons.energy_savings_leaf,
              title: 'Natura',
              type: 'Natura',
            ),
            SizedBox(
              width: 10,
            ),
            CategoryButton(
              colore: Colors.blueAccent,
              text: 'Borghi',
              icon: Icons.castle,
              title: 'Borghi',
              type: 'Borghi',
            ),
          ],
        ),
      ],
    );
  }
}
