import 'package:amathia/src/costants/costants.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/opened/recipe_card_open.dart';
import 'package:flutter/material.dart';

class RecipeCard extends StatelessWidget {
  final String title;
  final String description;
  final String location;
  final String image;
  final int time;
  final int peopleFor;
  final List<String> ingredients;

  const RecipeCard({
    super.key,
    required this.title,
    required this.description,
    required this.location,
    required this.image,
    required this.time,
    required this.peopleFor,
    required this.ingredients,
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
              location: location,
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
              image,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(child: Text('Immagine non disponibile'));
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(
                    child:
                        CircularProgressIndicator()); // Mostra un indicatore di caricamento
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 300,
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.schedule, size: 32),
                    const SizedBox(width: 5),
                    Text(
                      "$time min",
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                          text: "Porzione per ",
                          style: TextStyle(fontSize: 18)),
                      TextSpan(
                        text: "$peopleFor persone",
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: ingredients
                    .length, // Assicurati che `ingredients` non sia null
                itemBuilder: (context, index) {
                  return ListTile(
                    title:
                        Text(ingredients[index]), // Gestisci ingredienti nulli
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
