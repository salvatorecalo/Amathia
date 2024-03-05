import 'package:amathia/src/screens/home_page/pages/search_page/widget/category_button.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/searchbar.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/slider_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CategoryButton(
                      colore: Colors.orangeAccent,
                      text: 'Ricette',
                      icon: Icons.restaurant,
                      title: 'Ricette',
                      type: "ricette",
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 50),
                      child: const CategoryButton(
                        colore: Colors.pinkAccent,
                        text: 'Monumenti',
                        icon: Icons.account_balance,
                        title: 'Monumenti',
                        type: 'monumenti',
                      ),
                    ),
                    const CategoryButton(
                      colore: Colors.greenAccent,
                      text: 'Natura',
                      icon: Icons.pedal_bike,
                      title: 'Natura',
                      type: 'natura',
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
                      colore: Colors.blueAccent,
                      text: 'Mare',
                      icon: Icons.water,
                      title: 'Mare',
                      type: 'sea',
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    CategoryButton(
                      colore: Colors.purple,
                      text: 'Eventi',
                      icon: Icons.celebration,
                      title: 'Eventi',
                      type: 'eventi',
                    ),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                const SliderView(
                  message: 'Migliori di sempre',
                ),
                const SizedBox(
                  height: 50,
                ),
                const SliderView(
                  message: 'Estate 2022',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
