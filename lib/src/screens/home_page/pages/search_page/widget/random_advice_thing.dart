import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/card/city_card.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/card/monument_card.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/card/nature_card.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/card/recipe_card.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/opened/city_card_open.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/opened/monument_card_open.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/opened/nature_card_open.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/opened/recipe_card_open.dart';
import 'package:flutter/material.dart';

class RandomAdviceThing extends StatelessWidget {
  final String tableName;
  final Widget randomWidget;

  const RandomAdviceThing({super.key, required this.tableName, required this.randomWidget});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (tableName == "Ricette" && randomWidget is RecipeCard) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeOpenCard(
                title: (randomWidget as RecipeCard).title,
                image: (randomWidget as RecipeCard).image,
                description: (randomWidget as RecipeCard).description,
                time: (randomWidget as RecipeCard).time,
                ingredients: (randomWidget as RecipeCard).ingredients,
                peopleFor: (randomWidget as RecipeCard).peopleFor,
              ),
            ),
          );
        } else if (tableName == "Monumenti" && randomWidget is MonumentsCard) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MonumentOpenCard(
                title: (randomWidget as MonumentsCard).title,
                image: (randomWidget as MonumentsCard).image,
                description: (randomWidget as MonumentsCard).description,
                location: (randomWidget as MonumentsCard).location,
              ),
            ),
          );
        } else if (tableName == "Natura" && randomWidget is NatureCard) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NatureOpenCard(
                title: (randomWidget as NatureCard).title,
                image: (randomWidget as NatureCard).image,
                description: (randomWidget as NatureCard).description,
                location: (randomWidget as NatureCard).location,
              ),
            ),
          );
        } else if (tableName == "Borghi" && randomWidget is CityCard) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CityOpenCard(
                title: (randomWidget as CityCard).title,
                image: (randomWidget as CityCard).image,
                description: (randomWidget as CityCard).description,
              ),
            ),
          );
        }
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: ListTile(
          title: Text(tableName),
          subtitle: Text('Tap to see a random item'),
          trailing: Icon(Icons.arrow_forward),
        ),
      ),
    );
  }
}
