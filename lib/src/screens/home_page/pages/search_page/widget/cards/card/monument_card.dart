import 'package:amathia/src/costants/costants.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/opened/monument_card_open.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MonumentsCard extends StatelessWidget {
  String title;
  String location;
  String description;
  String image;
  MonumentsCard({
    super.key,
    required this.title,
    required this.location,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MonumentOpenCard(
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
        height: 200,
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Image.network(
              '$image.jpg',
              width: double.infinity,
              height: 100,
              fit: BoxFit.cover,
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
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
                          fontSize: 18,
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
