import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/opened/recipe_card_open.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/like_button.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RecipeCard extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final String time;
  final int peopleFor;
  String type;
  List ingredients;
  final String userId;
  RecipeCard({
    super.key,
    required this.title,
    required this.description,
    required this.image,
    required this.time,
    required this.peopleFor,
    required this.ingredients,
    required this.userId,
    required this.type,
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
              userId: userId,
              time: time,
              image: image,
              ingredients: ingredients,
            ),
          ),
        );
      },
      child: Container(
        width: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              image,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      LikeButton(
                        userId: userId,
                        itemId: title, // Unique identifier for the item
                        itemData: {
                          'title': title,
                          'image': image,
                          'type': 'Ricette',
                          'peoplefor': peopleFor,
                          'time': time.toString(),
                          'ingredients': ingredients,
                          'description': description,
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.schedule, size: 18),
                      const SizedBox(width: 5),
                      Text(
                        time,
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
