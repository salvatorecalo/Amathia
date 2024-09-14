import 'package:amathia/src/costants/costants.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/opened/nature_card_open.dart';
import 'package:flutter/material.dart';

class NatureCard extends StatelessWidget {
  String title;
  String image;
  String location;
  NatureCard({
    super.key,
    required this.title,
    required this.image,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NatureOpenCard(
              title: title,
              location: location,
              image: image,
              description: '',
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
                vertical: 10,
                horizontal: 15,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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
                          fontSize: 16,
                          overflow: TextOverflow.ellipsis,
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
