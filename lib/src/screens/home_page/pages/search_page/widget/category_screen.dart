import 'package:amathia/src/costants/costants.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/card/monument_card.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/card/nature_card.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/card/recipe_card.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/card/city_card.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CategoryScreen extends StatelessWidget {
  final Color bgcolor;
  final String category;
  final String type;
  final bool _pinned = true;
  final bool _snap = true;
  final bool _floating = true;

  const CategoryScreen({
    super.key,
    required this.bgcolor,
    required this.category,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              shape: const ContinuousRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              foregroundColor: bgcolor,
              backgroundColor: bgcolor,
              surfaceTintColor: bgcolor,
              pinned: _pinned,
              snap: _snap,
              floating: _floating,
              expandedHeight: 160.0,
              iconTheme: const IconThemeData(color: white),
              flexibleSpace: FlexibleSpaceBar(
                expandedTitleScale: 1.5,
                title: Text(
                  category,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
                background: Container(
                  color: bgcolor,
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  if (type == "ricette"){
                     return const RecipeCard(
                      title: '',
                      image: '',
                      location: '',
                      description: '',
                      time: 0,
                      peopleFor: 0,
                      ingredients: [],
                     );
                  } else if (type == "monumenti"){
                    return const MonumentsCard();
                  } else if (type == "natura"){
                    return const NatureCard();
                  } else if (type == "borghi"){
                    return const CityCard();
                  }
                },
                childCount: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}