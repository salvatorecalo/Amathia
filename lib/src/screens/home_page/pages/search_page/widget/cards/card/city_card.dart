import 'package:amathia/src/screens/home_page/pages/search_page/save_itinerary_button.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/like_button.dart';
import 'package:flutter/material.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/opened/city_card_open.dart';

// ignore: must_be_immutable
class CityCard extends StatelessWidget {
  String title;
  String image;
  String description;
  final String itineraryId;
  final String userId;
  CityCard({
    super.key,
    required this.itineraryId,
    required this.title,
    required this.image,
    required this.description,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CityOpenCard(
              userId: userId,
              title: title,
              description: description,
              image: image,
            ),
          ),
        );
      },
      child: SizedBox(
        width: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Restrizione per evitare overflow immagine
            ClipRRect(
              child: Image.network(
                image,
                width: double.infinity,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                      Icons.error); // Mostra un'icona in caso di errore
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Usa Flexible per evitare overflow
                  Flexible(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow
                          .ellipsis, // Troncamento del testo se è troppo lungo
                    ),
                  ),
                  Row(
                    children: [
                      LikeButton(
                        itemId: title,
                        userId: userId,
                        itemData: {
                          'title': title,
                          'image': image,
                          'type': 'Borghi',
                          'description': description,
                        },
                      ),
                      SaveItineraryButton(
                        itineraryId:
                            itineraryId, // Passa l'id dell'itinerario corrente (vuoto se nessun itinerario)
                        userId: userId,
                        itemData: {
                          'title': title,
                          'image': image,
                          'description': description,
                        },
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
