import 'dart:async';
import 'package:amathia/provider/dark_theme_provider.dart';
import 'package:amathia/src/costants/costants.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/opened/city_card_open.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/opened/monument_card_open.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/opened/nature_card_open.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/opened/recipe_card_open.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SearchDropdown extends ConsumerStatefulWidget {
  @override
  _SearchDropdownState createState() => _SearchDropdownState();
}

class _SearchDropdownState extends ConsumerState<SearchDropdown> {
  final TextEditingController _controller = TextEditingController();
  final SupabaseClient _supabase = Supabase.instance.client;

  Map<String, List<Map<String, dynamic>>> searchResults =
      {}; // Map of results per table
  bool isDropdownVisible = false;
  final SupabaseClient client = Supabase.instance.client;

  Timer? _debounceTimer;

  Future<void> search(String query) async {
    final searchText = query.trim().toLowerCase();
    print("Search text $searchText");

    // Se il campo di ricerca è vuoto, cancella i risultati e nascondi il dropdown
    if (searchText.isEmpty) {
      setState(() {
        searchResults = {};
        isDropdownVisible = false;
      });
      return;
    }

    // Mappa per accumulare i risultati
    Map<String, List<Map<String, dynamic>>> results = {};

    // Esegui la query sulle tabelle
    final naturaResponse = await _supabase
        .from('Natura')
        .select()
        .textSearch('title, location', searchText);
    if (naturaResponse.isNotEmpty) {
      results['Natura'] = naturaResponse;
    }

    final ricetteResponse = await _supabase
        .from('Ricette')
        .select()
        .textSearch('title', searchText);
    if (ricetteResponse.isNotEmpty) {
      results['Ricette'] = ricetteResponse;
    }

    final borghiResponse = await _supabase
        .from('Borghi')
        .select()
        .textSearch('title ,location', searchText);
    if (borghiResponse.isNotEmpty) {
      results['Borghi'] = borghiResponse;
    }

    final monumentiResponse = await _supabase
        .from('Monumenti')
        .select()
        .textSearch('title, location', searchText);
    if (monumentiResponse.isNotEmpty) {
      results['Monumenti'] = monumentiResponse;
    }

    // Aggiorna lo stato con i risultati e mostra il dropdown solo se ci sono risultati
    setState(() {
      searchResults = results;
      isDropdownVisible = results.isNotEmpty;
    });
  }

  void _onSearchTextChanged(String text) {
    // Annuliamo il precedente Timer se l'utente continua a digitare rapidamente
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer?.cancel();
    }

    // Imposta un nuovo Timer per ritardare la ricerca
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      search(text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(darkThemeProvider);
    return Column(
      children: [
        // Campo di testo per la ricerca
        TextField(
          controller: _controller,
          onChanged: _onSearchTextChanged, // Usa il metodo debounced
          decoration: InputDecoration(
            labelText: 'Search...',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        if (isDropdownVisible)
          Material(
            child: Container(
              constraints: BoxConstraints(
                maxHeight: 300, // Altezza massima per evitare overflow
              ),
              decoration: BoxDecoration(
                color: isDark ? Colors.black : Colors.white, // Sfondo dinamico
                boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black26)],
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView(
                shrinkWrap: true,
                children: searchResults.entries.expand((entry) {
                  final tableName = entry.key;
                  final tableResults = entry.value;

                  return [
                    ...tableResults.map((result) {
                      return ListTile(
                        leading: result['image'] != null
                            ? Image.network(
                                client.storage
                                    .from(tableName)
                                    .getPublicUrl(result['image']),
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : Icon(Icons.image_not_supported,
                                size: 50), // Icona di fallback
                        title: Text(
                          result['title'] ?? 'No title',
                          style: TextStyle(
                            color: isDark
                                ? Colors.white
                                : Colors.black, // Colore del testo
                          ),
                        ),
                        onTap: () {
                          // Navigazione in base al tipo di risultato
                          if (tableName == 'Ricette') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecipeOpenCard(
                                  title: result['title'],
                                  description: result['description_it'],
                                  image: client.storage
                                    .from(tableName)
                                    .getPublicUrl(result['image']),
                                  peopleFor: result['peopleFor'],
                                  time: result['time'],
                                  ingredients: result['ingredients_it'],
                                ),
                              ),
                            );
                          } else if (tableName == 'Monumenti') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MonumentOpenCard(
                                  title: result['title'],
                                  description: result['description_it'],
                                  location: result['location'],
                                  image: client.storage
                                    .from(tableName)
                                    .getPublicUrl(result['image']),
                                ),
                              ),
                            );
                          } else if (tableName == 'Borghi') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CityOpenCard(
                                  title: result['title'],
                                  description: result['description_it'],
                                  image: client.storage
                                    .from(tableName)
                                    .getPublicUrl(result['image']),
                                ),
                              ),
                            );
                          } else if (tableName == 'Natura') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NatureOpenCard(
                                  title: result['title'],
                                  location: result['location'],
                                  description: result['description_it'],
                                  image: client.storage
                                    .from(tableName)
                                    .getPublicUrl(result['image']),
                                ),
                              ),
                            );
                          }
                        },
                      );
                    }).toList(),
                  ];
                }).toList(),
              ),
            ),
          )
      ],
    );
  }
}
