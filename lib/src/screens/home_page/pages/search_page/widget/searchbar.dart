import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/opened/city_card_open.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/opened/monument_card_open.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/opened/nature_card_open.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/opened/recipe_card_open.dart';
import 'package:amathia/provider/dark_theme_provider.dart';

class SearchDropdown extends ConsumerStatefulWidget {
  final String userId;

  const SearchDropdown({
    super.key,
    required this.userId,
  });

  @override
  _SearchDropdownState createState() => _SearchDropdownState();
}

class _SearchDropdownState extends ConsumerState<SearchDropdown> {
  final TextEditingController _controller = TextEditingController();
  final SupabaseClient _supabase = Supabase.instance.client;

  Map<String, List<Map<String, dynamic>>> searchResults = {}; 
  bool isDropdownVisible = false;
  final SupabaseClient client = Supabase.instance.client;

  Timer? _debounceTimer;

  Future<void> search(String query) async {
    final searchText = query.trim().toLowerCase();

    if (searchText.isEmpty) {
      setState(() {
        searchResults = {};
        isDropdownVisible = false;
      });
      return;
    }

    Map<String, List<Map<String, dynamic>>> results = {};

    // Query per le tabelle
    final naturaResponse = await _supabase.from('Natura').select().textSearch('title, location', searchText);
    if (naturaResponse.isNotEmpty) results['Natura'] = naturaResponse;

    final ricetteResponse = await _supabase.from('Ricette').select().textSearch('title', searchText);
    if (ricetteResponse.isNotEmpty) results['Ricette'] = ricetteResponse;

    final borghiResponse = await _supabase.from('Borghi').select().textSearch('title ,location', searchText);
    if (borghiResponse.isNotEmpty) results['Borghi'] = borghiResponse;

    final monumentiResponse = await _supabase.from('Monumenti').select().textSearch('title, location', searchText);
    if (monumentiResponse.isNotEmpty) results['Monumenti'] = monumentiResponse;

    setState(() {
      searchResults = results;
      isDropdownVisible = results.isNotEmpty;
    });
  }

  void _onSearchTextChanged(String text) {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer?.cancel();
    }

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      search(text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(darkThemeProvider);

    // Calcola il numero totale di risultati
    final totalResultsCount = searchResults.values.expand((list) => list).length;

    return Stack(
      children: [
        Column(
          children: [
            // Campo di testo per la ricerca
            TextField(
              controller: _controller,
              onChanged: _onSearchTextChanged,
              decoration: InputDecoration(
                labelText: 'Search...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ],
        ),

        // Aggiungi il dropdown sopra il contenuto principale con un Stack
        if (isDropdownVisible)
          Positioned(
            top: 80,  // Regola questo valore in base a dove vuoi che appaia
            left: 0,
            right: 0,
            child: Material(
              elevation: 8,  // Imposta l'elevazione per il "z-index"
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: 56.0 * 5, // Mostra massimo 5 voci (56px per ogni ListTile)
                ),
                decoration: BoxDecoration(
                  color: isDark ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: totalResultsCount, // Numero totale di voci
                  itemBuilder: (context, index) {
                    int currentIndex = 0;

                    // Trova la voce corrispondente
                    for (final entry in searchResults.entries) {
                      final tableName = entry.key;
                      final tableResults = entry.value;

                      if (index < currentIndex + tableResults.length) {
                        final result = tableResults[index - currentIndex];
                        return ListTile(
                          leading: result['image'] != null
                              ? Image.network(
                                  client.storage.from(tableName).getPublicUrl(result['image']),
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                )
                              : Icon(Icons.image_not_supported, size: 50),
                          title: Text(
                            result['title'] ?? 'No title',
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          onTap: () {
                            // Navigazione alla pagina corretta in base alla tabella
                            if (tableName == 'Ricette') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RecipeOpenCard(
                                    userId: widget.userId,
                                    title: result['title'],
                                    description: result['description_it'],
                                    image: client.storage.from(tableName).getPublicUrl(result['image']),
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
                                    userId: widget.userId,
                                    title: result['title'],
                                    description: result['description_it'],
                                    location: result['location'],
                                    image: client.storage.from(tableName).getPublicUrl(result['image']),
                                  ),
                                ),
                              );
                            } else if (tableName == 'Borghi') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CityOpenCard(
                                    userId: widget.userId,
                                    title: result['title'],
                                    description: result['description_it'],
                                    image: client.storage.from(tableName).getPublicUrl(result['image']),
                                  ),
                                ),
                              );
                            } else if (tableName == 'Natura') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NatureOpenCard(
                                    userId: widget.userId,
                                    title: result['title'],
                                    location: result['location'],
                                    description: result['description_it'],
                                    image: client.storage.from(tableName).getPublicUrl(result['image']),
                                  ),
                                ),
                              );
                            }
                          },
                        );
                      }
                      currentIndex += tableResults.length;
                    }

                    return SizedBox.shrink();  // Ritorna un widget vuoto se non trovata la voce
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }
}
