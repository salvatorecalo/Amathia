import 'dart:math';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/card/city_card.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/card/monument_card.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/card/nature_card.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/card/recipe_card.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RandomDataFetcher extends StatefulWidget {
  const RandomDataFetcher({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RandomDataFetcherState createState() => _RandomDataFetcherState();
}

class _RandomDataFetcherState extends State<RandomDataFetcher> {
  final SupabaseClient client = Supabase.instance.client;
  List<dynamic> fetchedData = [];
  String tableName = '';
  final tables = ['Ricette', 'Natura', 'Borghi', 'Monumenti'];

  // Funzione che fetcha una tabella casuale
  Future<void> fetchRandomTable() async {
    final random = Random().nextInt(tables.length);
    tableName = tables[random];
    tables.remove(tableName);
    try {
      // Ottieni la risposta direttamente
      var response = await client.from(tableName).select('*');
      // Se la risposta è una lista, puoi aggiornare direttamente fetchedData
      setState(() {
        fetchedData = response as List<dynamic>; // Assicurati che sia una lista
      });
    } catch (e) {
      print('Errore nella fetch: $e');
      setState(() {
        fetchedData = []; // Se c'è un errore, impostiamo un elenco vuoto
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchRandomTable(); // Fetch iniziale
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tableName,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 20,
        ),
        fetchedData.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Expanded(
                // Assicurati che ListView abbia uno spazio allocato
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: fetchedData.length,
                  itemBuilder: (context, index) {
                    final item = fetchedData[index];
                    final imageUrl = item['image'] ?? '';
                    final title = item['title'] ?? '';
                    final String publicUrl =
                        client.storage.from(tableName).getPublicUrl(imageUrl);
    
                    if (tableName == "Ricette") {
                      return RecipeCard(
                        title: title,
                        description: item['description']!,
                        image: publicUrl,
                        time: item['time']!,
                        location: item['location']!,
                        peopleFor: item['peopleFor']!,
                        ingredients: item['ingredients']!,
                      );
                    } else if (tableName == "Monumenti") {
                      return MonumentsCard();
                    } else if (tableName == "Natura") {
                      return NatureCard();
                    } else if (tableName == "Borghi") {
                      return CityCard();
                    }
                  },
                ),
              ),
      ],
    );
  }
}
