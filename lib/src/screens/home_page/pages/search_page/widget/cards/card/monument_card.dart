import 'package:amathia/src/costants/costants.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/opened/monument_card_open.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/like_button.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/opencard.dart';
import 'package:flutter/material.dart';

class MonumentsCard extends StatelessWidget {
  const MonumentsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MonumentOpenCard(
              title: "Altare della pace",
              location: "Martano",
              description: "Martano ha questo altare",
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
                      "Basilica di Lecce",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                  LikeButton()
                ]
              ),
            ),
            const Row(
              children: [
                Icon(Icons.location_pin),
                SizedBox(width: 5,),
                Text("Lecce",style: TextStyle(fontSize: 18))
              ],
            )
          ],
        ),
      ),
    );
  }
}