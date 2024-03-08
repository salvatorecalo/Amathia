import 'package:amathia/src/costants/costants.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/card/eventi_card.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/card/monument_card.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/card/nature_card.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/card/recipe_card.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/card/sea_card.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CategoryScreen extends StatelessWidget {
  final Color bgcolor;
  final String category;
  final String type;
  bool _pinned = true;
  bool _snap = true;
  bool _floating = true;

  CategoryScreen({
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
                     return const RecipeCard();
                  } else if (type == "monumenti"){
                    return const MonumentsCard();
                  } else if (type == "natura"){
                    return const NatureCard();
                  } else if (type == "sea"){
                    return const SeaCard();
                  } else if (type == "eventi"){
                    return const EventiCard();
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