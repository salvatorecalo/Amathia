import 'package:amathia/src/costants/costants.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/card/city_card.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/card/monument_card.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/card/nature_card.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/card/recipe_card.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/opened/city_card_open.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/opened/monument_card_open.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/opened/nature_card_open.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/opened/recipe_card_open.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RandomAdviceThing extends StatelessWidget {
  final String tableName;
  final Widget randomWidget;
  final String userId;
  const RandomAdviceThing({super.key, required this.tableName, required this.randomWidget, required this.userId,});
  
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    String getString(tableName){
      String txt;
        if (tableName == "Ricette"){
          return txt = localizations!.recipeSuggestionText;
        } else if (tableName == "Monumenti"){
          return txt = localizations!.monumentsSuggestionText;
        } else if (tableName == "Natura"){
          return txt = localizations!.natureSuggestionText;
        } else if (tableName == "Borghi") {
          return txt = localizations!.citySuggestionText;
        }
        return "";
    }

    Color getColor(tableName){
      Color color;
        if (tableName == "Ricette"){
          return color = Colors.orangeAccent;
        } else if (tableName == "Monumenti"){
          return color = Colors.pinkAccent;
        } else if (tableName == "Natura"){
          return color = Colors.greenAccent;
        } else if (tableName == "Borghi") {
          return color = Colors.blueAccent;
        }
        return Colors.grey;
    }

    return GestureDetector(
      onTap: () {
        if (tableName == "Ricette" && randomWidget is RecipeCard) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeOpenCard(
                userId: userId,
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
          String txt = localizations!.citySuggestionText;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MonumentOpenCard(
                userId: userId,
                title: (randomWidget as MonumentsCard).title,
                image: (randomWidget as MonumentsCard).image,
                description: (randomWidget as MonumentsCard).description,
                location: (randomWidget as MonumentsCard).location,
              ),
            ),
          );
        } else if (tableName == "Natura" && randomWidget is NatureCard) {
          String txt = localizations!.natureSuggestionText;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NatureOpenCard(
                userId: userId,
                title: (randomWidget as NatureCard).title,
                image: (randomWidget as NatureCard).image,
                description: (randomWidget as NatureCard).description,
                location: (randomWidget as NatureCard).location,
              ),
            ),
          );
        } else if (tableName == "Borghi" && randomWidget is CityCard) {
          final txt = localizations!.monumentsSuggestionText;
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
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 18),
        child: Card(
          color: getColor(tableName),
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: ListTile(
            title: Text(tableName, style: TextStyle(color: white),),
            subtitle: Text(getString(tableName), style: TextStyle(color: white),),
            trailing: Icon(Icons.arrow_forward, color: white,),
          ),
        ),
      ),
    );
  }
}
