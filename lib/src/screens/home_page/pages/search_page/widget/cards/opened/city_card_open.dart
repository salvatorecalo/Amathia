import 'package:amathia/src/costants/costants.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/like_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// ignore: must_be_immutable
class CityOpenCard extends StatelessWidget {
  String? title;
  String? location;
  String? description;

  CityOpenCard({
    super.key,
    this.title,
    this.location,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Image.network(
            'https://picsum.photos/330/180',
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
                              "$title",
                              style: const TextStyle(
                                fontSize: 16,
                               fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const LikeButton()
                        ],
                      ),
                      const SizedBox(height: 20,),
                      const Row(
                        children: [
                          Icon(Icons.location_pin),
                          Text("Lecce")
                        ],
                      ),
                      const SizedBox(height: 40,),
                      const Text(
                        "Storia: ",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                         ),
                        ),
                        const SizedBox(height: 20,),
                        const Text(
                          "Descrizione del processo di creazione del piatto. Lorem impsum dolor at sit met de compostela. Descrizione del processo di creazione del piatto. Lorem impsum dolor at sit met de compostela Descrizione del processo di creazione del piatto. Lorem impsum dolor at sit met de compostela Descrizione del processo di creazione del piatto. Lorem impsum dolor at sit met de compostela Descrizione del processo di creazione del piatto. Lorem impsum dolor at sit met de compostela Descrizione del processo di creazione del piatto. Lorem impsum dolor at sit met d",
                          style: TextStyle(
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