import 'package:amathia/src/costants/costants.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RecipeOpenCard extends StatelessWidget {
  String title;
  String description;
  String image;
  int time;
  int peopleFor;
  RecipeOpenCard({
    super.key,
    required this.title,
    required this.description,
    required this.image,
    required this.peopleFor,
    required this.time,
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 20,
                  ),
                  child: ListView(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        width: 420,
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          const Icon(Icons.schedule),
                          const SizedBox(
                            width: 5,
                          ),
                          Text("$time min.")
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.person),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            '$peopleFor',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      const Text(
                        "Ingredienti: ",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Procedimento",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
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
