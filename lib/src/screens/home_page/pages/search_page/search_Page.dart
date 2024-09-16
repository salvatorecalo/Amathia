import 'dart:math';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/card/city_card.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/card/monument_card.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/card/nature_card.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/card/recipe_card.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/category_buttons.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/searchbar.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SupabaseClient client = Supabase.instance.client;
  final List<String> tables = ['Ricette', 'Borghi', 'Monumenti', 'Natura'];
  final Map<String, List<Widget>> fetchedData = {};
  bool isDataFetched =
      false; // Flag per tenere traccia se i dati sono stati caricati
  Future<void> fetchAllTables() async {
    if (isDataFetched) return; // Evita di ricaricare i dati se già caricati

    for (String tableName in tables) {
      try {
        final response = await client.from(tableName).select("*");
        final data = response as List<dynamic>;

        final widgetGenerated = data.map<Widget>((e) {
          if (tableName == "Ricette") {
            return Container(
              margin: const EdgeInsets.only(right: 10),
              child: RecipeCard(
                title: e['title'] ?? 'Titolo non disponibile',
                image: client.storage.from(tableName).getPublicUrl(e['image']),
                description: e['description'] ?? 'Descrizione non disponibile',
                time: e['time'] ?? 2,
                peopleFor: e['peopleFor'] ?? 1,
                ingredients: List<String>.from(e['ingredients']),
              ),
            );
          } else if (tableName == "Monumenti") {
            return Container(
              margin: const EdgeInsets.only(right: 10),
              child: MonumentsCard(
                location: e['location'] ?? 'Località non disponibile',
                image: client.storage.from(tableName).getPublicUrl(e['image']),
                title: e['title'] ?? 'Titolo non disponibile',
                description: e['description'] ?? 'Descrizione non disponibile',
              ),
            );
          } else if (tableName == "Natura") {
            return Container(
              margin: const EdgeInsets.only(right: 10),
              child: NatureCard(
                location: e['location'] ?? 'Località non disponibile',
                image: client.storage.from(tableName).getPublicUrl(e['image']),
                title: e['title'] ?? 'Titolo non disponibile',
              ),
            );
          } else if (tableName == "Borghi") {
            return Container(
              margin: const EdgeInsets.only(right: 10),
              child: CityCard(
                description: e['description'] ?? 'Località non disponibile',
                image: client.storage.from(tableName).getPublicUrl(e['image']),
                title: e['title'] ?? 'Titolo non disponibile',
              ),
            );
          }
          return const SizedBox.shrink();
        }).toList();

        widgetGenerated.shuffle();
        setState(() {
          fetchedData[tableName] = widgetGenerated;
        });
      } catch (e) {
        print("Errore nella fetch della tabella $tableName: $e");
      }
    }
    setState(() {
      isDataFetched = true; // Imposta il flag quando i dati sono stati caricati
    });
  }

  @override
  void initState() {
    super.initState();
    fetchAllTables(); // Carica i dati quando la pagina viene inizializzata
  }

  String getRandomTitle(String tableName) {
    final titles = {
          'Ricette': [
            'Da leccarsi i baffi',
            'Cucina con Gusto',
            'I Piatti del Giorno'
          ],
          'Borghi': [
            'Scopri i Borghi',
            'I Luoghi più Incantevoli',
            'Esplora i Borghi'
          ],
          'Monumenti': [
            'Monumenti da Visitare',
            'Storia e Cultura',
            'Meraviglie Storiche'
          ],
          'Natura': [
            'Ammira la Natura',
            'Paesaggi da Sogno',
            'Esplorazione Verde'
          ],
        }[tableName] ??
        ['Titolo Predefinito'];
    return titles[Random().nextInt(titles.length)];
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
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 30),
            child: const CategoryButtons(),
          ),
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
                    getRandomTitle(table), // Mostra un titolo casuale
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                Container(
                  height: 300,
                  margin: const EdgeInsets.only(left: 18, top: 20, bottom: 20),
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
        }),
      ],
    );
  }
}
