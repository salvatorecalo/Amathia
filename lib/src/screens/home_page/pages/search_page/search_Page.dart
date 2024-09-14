import 'dart:math';
import 'package:amathia/main.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/card/city_card.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/card/monument_card.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/card/nature_card.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/card/recipe_card.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/category_buttons.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/searchbar.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SupabaseClient client = Supabase.instance.client;
  final List<String> tables = ['Ricette', 'Borghi', 'Monumenti', 'Natura'];
  Map<String, List<Widget>> fetchedData = {};

  Future<void> fetchAllTables() async {
    for (String tableName in tables) {
      try {
        final response = await supabase.from(tableName).select("*");
        final widgetGenerated = response.map<Widget>((e) {
          if (tableName == "Ricette") {
            return RecipeCard(
              title: e['title'] ?? 'Titolo non disponibile',
              image: supabase.storage.from(tableName).getPublicUrl(e['image']),
              description: e['description'] ?? 'Descrizione non disponibile',
              time: e['time'] ?? 2,
              peopleFor: e['peopleFor'] ?? 1,
            );
          } else if (tableName == "Monumenti") {
            return MonumentsCard(
              location: e['location'] ?? 'Località non disponibile',
              image: supabase.storage.from(tableName).getPublicUrl(e['image']),
              title: e['title'] ?? 'Titolo non disponibile',
              description: e['description'] ?? 'Descrizione non disponibile',
            );
          } else if (tableName == "Natura") {
            return NatureCard(
              location: e['location'] ?? 'Località non disponibile',
              image: supabase.storage.from(tableName).getPublicUrl(e['image']),
              title: e['title'] ?? 'Titolo non disponibile',
            );
          } else if (tableName == "Borghi") {
            return CityCard(
              description: e['description'] ?? 'Località non disponibile',
              image: supabase.storage.from(tableName).getPublicUrl(e['image']),
              title: e['title'] ?? 'Titolo non disponibile',
            );
          }
          return const SizedBox.shrink();
        }).toList();

        // Aggiungi i widget generati alla mappa
        setState(() {
          fetchedData[tableName] = widgetGenerated;
        });
      } catch (e) {
        print("Errore nella fetch della tabella $tableName: $e");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAllTables(); // Chiamo la funzione che recupera i dati per tutte le tabelle
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverPadding(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 18),
          sliver: SliverAppBar(
            flexibleSpace: SearchBarApp(),
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            foregroundColor: Colors.transparent,
          ),
        ),
        const SliverToBoxAdapter(
          child: CategoryButtons(),
        ),
        ...tables.map((table) {
          // Se non ci sono dati per la tabella, mostra un indicatore di caricamento
          if (!fetchedData.containsKey(table) || fetchedData[table]!.isEmpty) {
            return const SliverToBoxAdapter(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          // Se ci sono dati, crea uno slider per la tabella
          return SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Text(
                    table,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(
                  height: 300,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: fetchedData[table]!.length,
                    itemBuilder: (context, index) => Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: fetchedData[table]![index],
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}
