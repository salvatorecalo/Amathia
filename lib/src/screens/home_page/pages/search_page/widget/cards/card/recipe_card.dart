import 'package:amathia/src/costants/costants.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/opened/recipe_card_open.dart';
import 'package:flutter/material.dart';

class RecipeCard extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final int time;
  final int peopleFor;

  const RecipeCard({
    super.key,
    required this.title,
    required this.description,
    required this.image,
    required this.time,
    required this.peopleFor,
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
              description: description,
              peopleFor: peopleFor,
              time: time,
              image: image,
            ),
          ),
        );
      },
      child: Container(
        width: 250,
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              '$image.jpg',
              width: double.infinity,
              height: 100,
              fit: BoxFit.cover,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.schedule, size: 18),
                      const SizedBox(width: 5),
                      Text(
                        "$time min",
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.people),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "$peopleFor",
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
