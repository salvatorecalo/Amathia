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
  Timer? _debounceTimer;
  Map<String, List<Map<String, dynamic>>> searchResults = {};

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
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    if (query.isEmpty) return Center(child: Text(localizations!.search));

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _performSearch(context);
    });

    return _buildSearchResults(context);
  }

  Future<void> _performSearch(BuildContext context) async {
    final searchText = query.trim().toLowerCase();
    if (searchText.isEmpty) return;

    Map<String, List<Map<String, dynamic>>> results = {};

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
  }

  Widget _buildSearchResults(BuildContext context) {
    if (searchResults.isEmpty) {
      return const Center(child: CircularProgressIndicator());
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
                placeholder: (context, url) => Center(child: const CircularProgressIndicator()),
              ),
              title: Text(result['title']),
              onTap: () => _navigateToDetail(context, tableName, result),
            );
          }
          currentIndex += tableResults.length;
        }
        return const SizedBox.shrink();
      },
    );
  }

  void _navigateToDetail(BuildContext context, String tableName, Map<String, dynamic> result) {
    Widget page;
    switch (tableName) {
      case 'Ricette':
        page = RecipeOpenCard(
          itineraryId: '',
          userId: '',
          title: result['title'],
          description: result['description_it'],
          image: _supabase.storage.from(tableName).getPublicUrl(result['image']),
          peopleFor: result['peopleFor'],
          time: result['time'],
          ingredients: result['ingredients_it'],
        );
        break;
      case 'Monumenti':
        page = MonumentOpenCard(
          itineraryId: '',
          userId: '',
          title: result['title'],
          description: result['description_it'],
          location: result['location'],
          image: _supabase.storage.from(tableName).getPublicUrl(result['image']),
        );
        break;
      case 'Borghi':
        page = CityOpenCard(
          itineraryId: '',
          userId: '',
          title: result['title'],
          description: result['description_it'],
          image: _supabase.storage.from(tableName).getPublicUrl(result['image']),
        );
        break;
      case 'Natura':
        page = NatureOpenCard(
          itineraryId: '',
          userId: '',
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
