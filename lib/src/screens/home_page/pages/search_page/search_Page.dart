import 'package:amathia/src/screens/home_page/pages/search_page/widget/category_button.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/searchbar.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/slider_view.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 100,
                  child: SearchBarApp(),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CategoryButton(
                      colore: Colors.orangeAccent,
                      text: 'Ricette',
                      icon: Icons.restaurant,
                      title: 'Ricette',
                      type: "ricette",
                    ),
                    SizedBox(width: 10,),
                    CategoryButton(
                      colore: Colors.pinkAccent,
                      text: 'Monumenti',
                      icon: Icons.account_balance,
                      title: 'Monumenti',
                      type: 'monumenti',
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CategoryButton(
                      colore: Colors.greenAccent,
                      text: 'Natura',
                      icon: Icons.pedal_bike,
                      title: 'Natura',
                      type: 'natura',
                    ),
                    SizedBox(width: 10,),
                    CategoryButton(
                      colore: Colors.blueAccent,
                      text: 'Borghi',
                      icon: Icons.castle,
                      title: 'Borghi',
                      type: 'borghi',
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                SizedBox(
                  height: 200,
                  child: RandomDataFetcher(),
                ),
                const SizedBox(
                  height: 50,
                ),
                SizedBox(
                  height: 200,
                  child: RandomDataFetcher(),
                ),
                const SizedBox(
                  height: 50,
                ),
               SizedBox(
                height: 200,
                child: RandomDataFetcher(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
