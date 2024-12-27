import 'dart:math';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:amathia/main.dart';
import 'package:amathia/src/costants/costants.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/card/monument_card.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/card/nature_card.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/card/recipe_card.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/card/city_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ignore: must_be_immutable
class CategoryScreen extends StatefulWidget {
  final Color bgcolor;
  final String category;
  final String type;
  final String userId;
  const CategoryScreen({
    super.key,
    required this.bgcolor,
    required this.category,
    required this.type,
    required this.userId,
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final bool _pinned = true;
  final bool _snap = true;
  final bool _floating = true;

  List<Widget> fetchedData = [];

  // Spostiamo la chiamata di fetchTable qui, in modo che sia sicuro usare il contesto
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final localizations = AppLocalizations.of(context);
    if (localizations != null) {
      fetchTable(localizations);
    }
  }

  Future<void> fetchTable(AppLocalizations localizations) async {
    try {
      final response = await supabase.from(widget.type).select("*");
      final SupabaseClient client = Supabase.instance.client;
      String language = Localizations.localeOf(context).languageCode;

      final widgetGenerated = response.map<Widget>((e) {
        if (language == 'en') {
          if (widget.type == "Ricette") {
            return Container(
              margin: const EdgeInsets.all(10),
              child: RecipeCard(
                userId: widget.userId,
                title: e['title'],
                image:
                    client.storage.from(widget.type).getPublicUrl(e['image']),
                description: e['description_en'],
                time: e['time'].toString(),
                peopleFor: e['peopleFor'] ?? 1,
                ingredients: List<String>.from(e['ingredients_en'] ?? []),
                type: widget.type, // Pass type to each card
              ),
            );
          } else if (widget.type == "Monumenti") {
            return Container(
              margin: const EdgeInsets.all(20),
              child: MonumentsCard(
                userId: widget.userId,
                location: e['location'],
                image:
                    client.storage.from(widget.type).getPublicUrl(e['image']),
                title: e['title'],
                description: e['description_en'],
                type: widget.type, // Pass type to each card
              ),
            );
          } else if (widget.type == "Natura") {
            return Container(
              margin: const EdgeInsets.all(20),
              child: NatureCard(
                userId: widget.userId,
                location: e['location'],
                image:
                    client.storage.from(widget.type).getPublicUrl(e['image']),
                title: e['title'],
                description: e['description_en'],
                type: widget.type, // Pass type to each card
              ),
            );
          } else if (widget.type == "Borghi") {
            return Container(
              margin: const EdgeInsets.all(20),
              child: CityCard(
                type: widget.type, // Pass type to each card
                userId: widget.userId,
                itineraryId: e['id'],
                description: e['description_en'],
                image:
                    client.storage.from(widget.type).getPublicUrl(e['image']),
                title: e['title'],
              ),
            );
          }
          return const SizedBox.shrink();
        } else {
          if (widget.type == "Ricette") {
            return Container(
              margin: const EdgeInsets.all(20),
              child: RecipeCard(
                userId: widget.userId,
                title: e['title'],
                image:
                    client.storage.from(widget.type).getPublicUrl(e['image']),
                description: e['description_it'],
                time: e['time'].toString(),
                peopleFor: e['peopleFor'] ?? 1,
                ingredients: List<String>.from(e['ingredients_it'] ?? []),
                type: widget.type, // Pass type to each card
              ),
            );
          } else if (widget.type == "Monumenti") {
            return Container(
              margin: const EdgeInsets.all(20),
              child: MonumentsCard(
                userId: widget.userId,
                location: e['location'],
                image:
                    client.storage.from(widget.type).getPublicUrl(e['image']),
                title: e['title'],
                description: e['description_it'],
                type: widget.type, // Pass type to each card
              ),
            );
          } else if (widget.type == "Natura") {
            return Container(
              margin: const EdgeInsets.all(20),
              child: NatureCard(
                userId: widget.userId,
                location: e['location'],
                image:
                    client.storage.from(widget.type).getPublicUrl(e['image']),
                title: e['title'],
                description: e['description_it'],
                type: widget.type, // Pass type to each card
              ),
            );
          } else if (widget.type == "Borghi") {
            return Container(
              margin: const EdgeInsets.all(20),
              child: CityCard(
                type: widget.type, // Pass type to each card
                itineraryId: e['uuid'],
                userId: widget.userId,
                description: e['description_it'],
                image:
                    client.storage.from(widget.type).getPublicUrl(e['image']),
                title: e['title'],
              ),
            );
          }
          return const SizedBox.shrink();
        }
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
