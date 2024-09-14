import 'dart:math';

import 'package:flutter/material.dart';
import 'package:amathia/main.dart';
import 'package:amathia/src/costants/costants.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/card/monument_card.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/card/nature_card.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/card/recipe_card.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/card/city_card.dart';

// ignore: must_be_immutable
class CategoryScreen extends StatefulWidget {
  final Color bgcolor;
  final String category;
  final String type;

  const CategoryScreen({
    super.key,
    required this.bgcolor,
    required this.category,
    required this.type,
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final bool _pinned = true;
  final bool _snap = true;
  final bool _floating = true;

  List<Widget> fetchedData = [];

  Future<void> fetchTable() async {
    try {
      final response = await supabase.from(widget.type).select("*");
      final widgetGenerated = response.map<Widget>((e) {
        if (widget.type == "Ricette") {
          return Container(
            margin: const EdgeInsets.all(20),
            child: RecipeCard(
              title: e['title'] ?? 'Titolo non disponibile',
              image:
                  supabase.storage.from(widget.type).getPublicUrl(e['image']),
              description: e['description'] ?? 'Descrizione non disponibile',
              time: e['time'] ?? 2,
              peopleFor: e['peopleFor'] ?? 1,
            ),
          );
        } else if (widget.type == "Monumenti") {
          return Container(
            margin: const EdgeInsets.all(20),
            child: MonumentsCard(
              location: e['location'] ?? 'Località non disponibile',
              image:
                  supabase.storage.from(widget.type).getPublicUrl(e['image']),
              title: e['title'] ?? 'Titolo non disponibile',
              description: e['description'] ?? 'Descrizione non disponibile',
            ),
          );
        } else if (widget.type == "Natura") {
          return Container(
            margin: const EdgeInsets.all(20),
            child: NatureCard(
              location: e['location'] ?? 'Località non disponibile',
              image:
                  supabase.storage.from(widget.type).getPublicUrl(e['image']),
              title: e['title'] ?? 'Titolo non disponibile',
            ),
          );
        } else if (widget.type == "Borghi") {
          return Container(
            margin: const EdgeInsets.all(20),
            child: CityCard(
              description: e['description'] ?? 'Descrizione non disponibile',
              image:
                  supabase.storage.from(widget.type).getPublicUrl(e['image']),
              title: e['title'] ?? 'Titolo non disponibile',
            ),
          );
        }
        return const SizedBox.shrink();
      }).toList();
      widgetGenerated.shuffle(Random());

      setState(() {
        fetchedData = widgetGenerated;
      });
    } catch (e) {
      print("Errore nella fetch della tabella ${widget.type}: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchTable();
  }

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
              foregroundColor: widget.bgcolor,
              backgroundColor: widget.bgcolor,
              surfaceTintColor: widget.bgcolor,
              pinned: _pinned,
              snap: _snap,
              floating: _floating,
              expandedHeight: 160.0,
              iconTheme: const IconThemeData(color: white),
              flexibleSpace: FlexibleSpaceBar(
                expandedTitleScale: 1.5,
                title: Text(
                  widget.category,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
                background: Container(
                  color: widget.bgcolor,
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  if (index < fetchedData.length) {
                    return fetchedData[index];
                  }
                  return const SizedBox.shrink();
                },
                childCount: fetchedData.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
