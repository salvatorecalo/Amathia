import 'package:amathia/src/screens/home_page/pages/search_page/empty_results.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/opened/city_card_open.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/opened/monument_card_open.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/opened/nature_card_open.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/opened/recipe_card_open.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomSearchDelegate extends SearchDelegate {
  final SupabaseClient _supabase = Supabase.instance.client;
  final String userId;
  Timer? _debounceTimer;
  Map<String, List<Map<String, dynamic>>> searchResults = {};
  bool _searchPerformed = false;

  CustomSearchDelegate({required this.userId});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
          searchResults.clear();
          showSuggestions(context);
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (searchResults.isEmpty) {
      return Center(child: EmptyResult());
    }

    return _buildSearchResults(context);
  }


  Future<void> _performSearch(BuildContext context) async {
    final searchText = query.trim().toLowerCase();
    if (searchText.isEmpty) return;

    _searchPerformed = true;
    searchResults.clear();

    Map<String, List<Map<String, dynamic>>> results = {};

    // Eseguiamo le query di ricerca
    final naturaResponse = await _supabase
        .from('Natura')
        .select()
        .ilike('title, location', '%$searchText%');
    if (naturaResponse.isNotEmpty) results['Natura'] = naturaResponse;

    final ricetteResponse = await _supabase
        .from('Ricette')
        .select()
        .ilike('title', '%$searchText%');
    if (ricetteResponse.isNotEmpty) results['Ricette'] = ricetteResponse;

    final borghiResponse = await _supabase
        .from('Borghi')
        .select()
        .ilike('title ,location', '%$searchText%');
    if (borghiResponse.isNotEmpty) results['Borghi'] = borghiResponse;

    final monumentiResponse = await _supabase
        .from('Monumenti')
        .select()
        .ilike('title, location', '%$searchText%');
    if (monumentiResponse.isNotEmpty) results['Monumenti'] = monumentiResponse;

    searchResults = results;
    showResults(context);

    // Salva la ricerca su Supabase
    await _saveSearchToSupabase(searchText);
  }

  Future<void> _saveSearchToSupabase(String searchText) async {
    final response = await _supabase.from('ultima_ricerca').insert([
      {
        'user_id': userId,
        'search_query': searchText,
        'timestamp': DateTime.now().toIso8601String(),
      }
    ]);

    if (response.error != null) {
      print('Errore nel salvataggio della ricerca: ${response.error!.message}');
    } else {
      print('Ricerca salvata con successo');
    }
  }


  Widget _buildSearchResults(BuildContext context) {
    if (searchResults.isEmpty) {
      return Center(child: EmptyResult(),); // Mostra "No Results"
    }

    return ListView.builder(
      itemCount: searchResults.values.expand((list) => list).length,
      itemBuilder: (context, index) {
        int currentIndex = 0;
        for (final entry in searchResults.entries) {
          final tableName = entry.key;
          final tableResults = entry.value;

          if (index < currentIndex + tableResults.length) {
            final result = tableResults[index - currentIndex];
            return ListTile(
              leading: CachedNetworkImage(
                imageUrl: _supabase.storage
                    .from(tableName)
                    .getPublicUrl(result['image']),
                width: 50,
                height: 80,
                fit: BoxFit.cover,
                errorWidget: (context, error, stackTrace) => const Icon(Icons.error),
                placeholder: (context, url) => const Icon(Icons.image), // Placeholder icon
              ),
              title: Text(result['title']),
              onTap: () => _navigateToDetail(context, tableName, result), // Navigazione alla pagina di dettaglio
            );
          }
          currentIndex += tableResults.length;
        }
        return const SizedBox.shrink();
      },
    );
  }


  @override
  Widget buildSuggestions(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    // Mostra "No results" solo dopo aver eseguito una ricerca
    if (_searchPerformed && query.isEmpty) {
      return Center(child: EmptyResult());
    }

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 900), () {
      _performSearch(context); // Chiamata alla ricerca solo dopo il debounce
    });

    return _buildSearchResults(context); // Mostriamo i risultati dinamicamente
  }


  void _navigateToDetail(BuildContext context, String tableName, Map<String, dynamic> result) {

    Widget page;
    final itineraryId = result['id'].toString(); // Converti l'ID in String

    switch (tableName) {
      case 'Ricette':
        page = RecipeOpenCard(
          itineraryId: itineraryId,  // Ora è una Stringa
          userId: userId,
          title: result['title'],
          description: result['description_it'],
          image: _supabase.storage.from(tableName).getPublicUrl(result['image']),
          peopleFor: result['peopleFor'],
          time: result['time'],
          ingredients: List<String>.from(result['ingredients_it'] ?? []),
        );
        break;
      case 'Monumenti':
        page = MonumentOpenCard(
          itineraryId: itineraryId,  // Ora è una Stringa
          userId: userId,
          title: result['title'],
          description: result['description_it'],
          location: result['location'],
          image: _supabase.storage.from(tableName).getPublicUrl(result['image']),
        );
        break;
      case 'Borghi':
        page = CityOpenCard(
          itineraryId: itineraryId,  // Ora è una Stringa
          userId: userId,
          title: result['title'],
          description: result['description_it'],
          image: _supabase.storage.from(tableName).getPublicUrl(result['image']),
        );
        break;
      case 'Natura':
        page = NatureOpenCard(
          itineraryId: itineraryId,  // Ora è una Stringa
          userId: userId,
          title: result['title'],
          location: result['location'],
          description: result['description_it'],
          image: _supabase.storage.from(tableName).getPublicUrl(result['image']),
        );
        break;
      default:
        return;
    }

    close(context, null); // Chiude la search bar
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

}