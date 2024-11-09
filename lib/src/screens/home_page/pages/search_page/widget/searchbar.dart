import 'package:amathia/provider/dark_theme_provider.dart';
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

  Map<String, List<Map<String, dynamic>>> searchResults = {}; // Map of results per table
  bool isDropdownVisible = false;
  final SupabaseClient client = Supabase.instance.client;

  Future<void> search(String query) async {
    final searchText = query.trim().toLowerCase();
    print("Search text $searchText");
    
    // If the search field is empty, clear results and hide the dropdown
    if (searchText.isEmpty) {
      setState(() {
        searchResults = {};
        isDropdownVisible = false;
      });
      return;
    }

    // Map to accumulate results
    Map<String, List<Map<String, dynamic>>> results = {};

    // Query the "Natura" table
    final naturaResponse = await _supabase
        .from('Natura')
        .select()
        .textSearch('title', searchText);
    if (naturaResponse.isNotEmpty) {
      results['Natura'] = naturaResponse;
    }

    // Query the "Ricette" table
    final ricetteResponse = await _supabase
        .from('Ricette')
        .select()
        .textSearch('title', searchText);
    if (ricetteResponse.isNotEmpty) {
      results['Ricette'] = ricetteResponse;
    }

    // Query the "Borghi" table
    final borghiResponse = await _supabase
        .from('Borghi')
        .select()
        .textSearch('title', searchText);
    if (borghiResponse.isNotEmpty) {
      results['Borghi'] = borghiResponse;
    }

    // Query the "Monumenti" table
    final monumentiResponse = await _supabase
        .from('Monumenti')
        .select()
        .textSearch('title', searchText);
    if (monumentiResponse.isNotEmpty) {
      results['Monumenti'] = monumentiResponse;
    }

    // Update state with the results and show dropdown only if there are results
    setState(() {
      searchResults = results;
      isDropdownVisible = results.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(darkThemeProvider);
    return Column(
    children: [
      // Search text field
      TextField(
        controller: _controller,
        onChanged: search,
        decoration: InputDecoration(
          labelText: 'Search...',
          prefixIcon: Icon(Icons.search),
        ),
      ),
        
      // Dropdown menu displaying results for each table
      if (isDropdownVisible)
        Container(
          color: isDark ? Colors.black : Colors.white, // Use Colors.black and Colors.white directly or import custom constants
          child: Expanded(
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
                              client.storage.from(tableName).getPublicUrl(result['image']),
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : Icon(Icons.image_not_supported, size: 50), // Placeholder icon if image is missing
                      title: Text(result['title'] ?? 'No title'),
                      onTap: () {
                        if (tableName == 'Ricette') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecipeOpenCard(
                                title: result['title'],
                                description: result['description_it'],
                                image: result['image'],
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
                                image: result['image'],
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
                                image: result['image'],
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
                                image: result['image'],
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
        ),
    ],
        );
  }
}
