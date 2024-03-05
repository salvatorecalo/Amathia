import 'package:amathia/src/costants/costants.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/opened/recipe_card_open.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/like_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeOpenCard(
              title:"titolo",
              description: "Lunga descrizionr perchè",
              location: "Martano",
            ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Image.network(
              'https://picsum.photos/330/180',
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 420,
                    child: Text(
                      "Orecchiette melanzane e pomodorini “scattarisciati”",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                  LikeButton()
                ]
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.schedule, size: 32),
                    SizedBox(width: 5,),
                    Text("50 min",style: TextStyle(fontSize: 18))
                  ],
                ),
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(text: "Porzione per ", style: TextStyle(fontSize: 18)),
                      TextSpan(text: "8 persone", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
                    ]
                  )
                  )
              ],
            )
          ],
        ),
      ),
    );
  }
}