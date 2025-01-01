import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/opened/nature_card_open.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/like_button.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/save_itinerary_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NatureCard extends StatelessWidget {
  String title;
  String image;
  String location;
  String description;
  final String userId;
  String type;
  NatureCard({
    super.key,
    required this.title,
    required this.image,
    required this.location,
    required this.description,
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
            builder: (context) => NatureOpenCard(
              userId: userId,
              title: title,
              location: location,
              image: image,
              description: description,
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
              margin: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 15,
              ),
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
                              'location': location,
                              'description': description,
                              'type': 'Natura'
                            },
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          // Aggiungi SaveItineraryButton
                          SaveItineraryButton(
                            type: type,
                            itineraryId: '', // Passa l'id dell'itinerario corrente, vuoto se non presente
                            userId: userId,
                            itemData: {
                              'title': title,
                              'image': image,
                              'location': location,
                              'description': description,
                              'type': 'Natura',
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_pin,
                        size: 18,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        location,
                        style: const TextStyle(
                          fontSize: 16,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
