import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/opened/city_card_open.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/opened/monument_card_open.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/opened/nature_card_open.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/opened/recipe_card_open.dart';
import 'package:amathia/provider/dark_theme_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  OverlayEntry? _overlayEntry;

  Future<void> search(String query) async {
    final searchText = query.trim().toLowerCase();

    if (searchText.isEmpty) {
      // Se il testo è vuoto, rimuovi i risultati e nascondi l'overlay
      setState(() {
        searchResults = {};
        isDropdownVisible = false;
      });
      _removeDropdown(); // Nascondi l'overlay
      return;
    }

    Map<String, List<Map<String, dynamic>>> results = {};

    // Query per le tabelle
    final naturaResponse = await _supabase
        .from('Natura')
        .select()
        .textSearch('title, location', searchText);
    if (naturaResponse.isNotEmpty) results['Natura'] = naturaResponse;

    final ricetteResponse = await _supabase
        .from('Ricette')
        .select()
        .textSearch('title', searchText);
    if (ricetteResponse.isNotEmpty) results['Ricette'] = ricetteResponse;

    final borghiResponse = await _supabase
        .from('Borghi')
        .select()
        .textSearch('title ,location', searchText);
    if (borghiResponse.isNotEmpty) results['Borghi'] = borghiResponse;

    final monumentiResponse = await _supabase
        .from('Monumenti')
        .select()
        .textSearch('title, location', searchText);
    if (monumentiResponse.isNotEmpty) results['Monumenti'] = monumentiResponse;

    setState(() {
      searchResults = results;
      isDropdownVisible = results.isNotEmpty;
    });

    if (isDropdownVisible) {
      _showDropdown();
    } else {
      _removeDropdown();
    }
  }

  void _onSearchTextChanged(String text) {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer?.cancel();
    }

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      search(text);
    });
  }

  // Mostra il dropdown nell'Overlay
  void _showDropdown() {
    if (_overlayEntry != null) return;

    // Recupera la larghezza del TextField per applicarla al dropdown
    final width = MediaQuery.of(context).size.width;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 100, // Posizione verticale per il dropdown
        left: 18, // Distanza orizzontale sinistra, stessa del TextField
        right: 18, // Distanza orizzontale destra, stessa del TextField
        child: Material(
          elevation: 3, // Elevazione per il "z-index"
          child: Container(
            color: Colors.white,
            width: width - 36, // Applica la larghezza del TextField
            height: 400,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: searchResults.values.expand((list) => list).length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                int currentIndex = 0;
                // Trova la voce corrispondente
                for (final entry in searchResults.entries) {
                  final tableName = entry.key;
                  final tableResults = entry.value;

                  if (index < currentIndex + tableResults.length) {
                    final result = tableResults[index - currentIndex];
                    return ListTile(
                      title: Text(
                        result['title'] ?? 'No title',
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      onTap: () {
                        // Navigazione alla pagina corretta in base alla tabella
                        if (tableName == 'Ricette') {
                          _removeDropdown();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecipeOpenCard(
                                userId: widget.userId,
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
                          _removeDropdown();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MonumentOpenCard(
                                userId: widget.userId,
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
                          _removeDropdown();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CityOpenCard(
                                userId: widget.userId,
                                title: result['title'],
                                description: result['description_it'],
                                image: client.storage
                                    .from(tableName)
                                    .getPublicUrl(result['image']),
                              ),
                            ),
                          );
                        } else if (tableName == 'Natura') {
                          _removeDropdown();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NatureOpenCard(
                                userId: widget.userId,
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
                  }
                  currentIndex += tableResults.length;
                }

                return SizedBox
                    .shrink(); // Ritorna un widget vuoto se non trovata la voce
              },
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  // Rimuove il dropdown dall'Overlay
  void _removeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);

    return Column(
      children: [
        // Campo di testo per la ricerca
        TextField(
          controller: _controller,
          onChanged: _onSearchTextChanged,
          decoration: InputDecoration(
            labelText: localization!.search,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            prefixIcon: Icon(Icons.search),
          ),
        ),
      ],
    );
  }
}
