import 'package:amathia/src/costants/costants.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/opened/event_card_open.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/like_button.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/opencard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EventiCard extends StatelessWidget {
  const EventiCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventiOpenCard(),
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
          mainAxisAlignment: MainAxisAlignment.start,
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
                      "Notte della Taranta",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                  LikeButton()
                ]
              ),
            ),
            const Text("Melpignano"),
            const Row(
              children: [
                Icon(Icons.calendar_month, size: 32),
                SizedBox(width: 5,),
                Text("17/01/24",style: TextStyle(fontSize: 18))
              ],
            )
          ],
        ),
      ),
    );
  }
}