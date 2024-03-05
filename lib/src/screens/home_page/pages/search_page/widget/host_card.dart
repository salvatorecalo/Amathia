import 'package:amathia/src/costants/costants.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/card/recipe_card.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/opened/recipe_card_open.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/like_button.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/opencard.dart';
import 'package:flutter/material.dart';

class HostCard extends StatelessWidget {
  final String title;
  final String location;
  final String description;

  const HostCard({
    super.key,
    required this.title,
    required this.location,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeOpenCard(
              title: title,
              location: location,
              description: description,
            ),
          ),
        );
      },
      child: Container(
        decoration: const BoxDecoration(
          color: white,
        ),
        margin: const EdgeInsets.only(right: 30),
        width: 200,
        child: Column(
          children: [
            Image.network('https://picsum.photos/seed/picsum/200/100'),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 10, right: 16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title.replaceRange(7, title.length, '...'),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            letterSpacing: 1,
                          ),
                        ),
                        const LikeButton(),
                      ],
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      location,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                  ]),
            )
          ],
        ),
      ),
    );
  }
}