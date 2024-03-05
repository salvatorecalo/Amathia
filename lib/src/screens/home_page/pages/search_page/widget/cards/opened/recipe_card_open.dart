import 'package:amathia/src/costants/costants.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/like_button.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RecipeOpenCard extends StatelessWidget {
  String? title;
  String? rating;
  String? location;
  String? description;

  RecipeOpenCard({
    super.key,
    this.title,
    this.rating,
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
                      const Row(
                        children: [
                          SizedBox(
                            width: 420,
                            child: Text(
                              "Orecchiette melanzane e pomodorini “scattarisciati”",
                              style: TextStyle(
                                fontSize: 20,
                               fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          LikeButton()
                        ],
                      ),
                      const SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.schedule),
                              Text("50 min.")
                            ],
                          ),
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Porzione per ' 
                                ),
                                TextSpan(
                                  text: '8 persone',
                                  style: TextStyle(fontWeight: FontWeight.w700)
                                )
                              ]
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40,),
                      const Text(
                        "Ingredienti: ",
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