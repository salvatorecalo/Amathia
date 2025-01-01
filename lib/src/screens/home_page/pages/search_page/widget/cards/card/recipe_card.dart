import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/opened/recipe_card_open.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/like_button.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/save_itinerary_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
            ClipRRect(
              child: CachedNetworkImage(
                imageUrl: image,
                width: double.infinity,
                height: 100,
                fit: BoxFit.cover,
                errorWidget: (context, error, stackTrace) {
                  return const Icon(
                      Icons.error); // Mostra un'icona in caso di errore
                },
                placeholder: (context, url) {
                    return Center(child: const CircularProgressIndicator());
                },
              ),
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
                      // Usa Flexible per evitare overflow nel titolo
                      Flexible(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                          overflow: TextOverflow.ellipsis, // Troncamento del testo se troppo lungo
                        ),
                      ),
                      Row(
                        children: [
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
                          const SizedBox(width: 10),
                          // Aggiungi SaveItineraryButton
                          SaveItineraryButton(
                            type: type,
                            itineraryId: '', // Passa l'id dell'itinerario corrente, vuoto se non presente
                            userId: userId,
                            itemData: {
                              'title': title,
                              'image': image,
                              'description': description,
                              'time': time,
                              'peopleFor': peopleFor,
                              'ingredients': ingredients,
                              'type': 'Ricette',
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
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
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.people),
                      const SizedBox(width: 10),
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
