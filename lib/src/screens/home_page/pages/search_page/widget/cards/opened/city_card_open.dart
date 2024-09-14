import 'package:amathia/src/costants/costants.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/like_button.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CityOpenCard extends StatelessWidget {
  String title;
  String description;
  String image;
  CityOpenCard({
    super.key,
    required this.title,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Image.network(
            '$image.jpg',
            fit: BoxFit.fitHeight,
            width: double.infinity,
            height: 350,
            alignment: Alignment.center,
          ),
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: IconButton(
                hoverColor: Colors.white,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  size: 28,
                ),
              ),
            ),
          ),
          SizedBox(
            height: double.infinity,
            child: FractionallySizedBox(
              alignment: Alignment.bottomCenter,
              heightFactor: 0.7,
              widthFactor: 1,
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  color: white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 420,
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const LikeButton()
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      const Text(
                        "Storia: ",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        description,
                        style: const TextStyle(
                          height: 2,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
