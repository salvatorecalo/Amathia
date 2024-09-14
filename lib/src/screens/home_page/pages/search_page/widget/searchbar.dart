import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SearchBarApp extends StatefulWidget {
  const SearchBarApp({super.key});

  @override
  State<SearchBarApp> createState() => _SearchBarAppState();
}

class _SearchBarAppState extends State<SearchBarApp> {
  final supabase = Supabase.instance.client; // Client di Supabase
  final SearchController _searchController = SearchController();
  List<Map<String, dynamic>> searchResults = []; // Risultati della ricerca
  bool isLoading = false;

  // Funzione per eseguire la ricerca
  Future<void> _search(String query) async {
    setState(() {
      isLoading = true;
    });

    // Esegui la ricerca nelle tabelle
    final ricetteResponse =
        await supabase.from('Ricette').select().ilike('title', '%$query%');
    final monumentiResponse =
        await supabase.from('Monumenti').select().ilike('title', '%$query%');
    final naturaResponse =
        await supabase.from('Natura').select().ilike('title', '%$query%');
    final borghiResponse =
        await supabase.from('Borghi').select().ilike('title', '%$query%');

    // Unisci i risultati in una lista
    setState(() {
      searchResults = [
        ...ricetteResponse.map((e) => {'type': 'Ricetta', 'data': e}),
        ...monumentiResponse.map((e) => {'type': 'Monumento', 'data': e}),
        ...naturaResponse.map((e) => {'type': 'Natura', 'data': e}),
        ...borghiResponse.map((e) => {'type': 'Borgo', 'data': e}),
      ];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      builder: (BuildContext context, SearchController controller) {
        return SearchBar(
          hintText: 'Cosa vuoi cercare?',
          controller: _searchController,
          padding: const WidgetStatePropertyAll<EdgeInsets>(
              EdgeInsets.symmetric(horizontal: 16.0)),
          onTap: () {
            controller.openView();
          },
          onChanged: (query) {
            _search(query); // Esegui la ricerca quando cambia il testo
          },
          leading: const Icon(Icons.search),
        );
      },
      suggestionsBuilder: (BuildContext context, SearchController controller) {
        if (isLoading) {
          return [const Center(child: CircularProgressIndicator())];
        }

        return List<ListTile>.generate(searchResults.length, (int index) {
          final result = searchResults[index];
          final String item = result['data']['title'] ?? 'Senza nome';

          return ListTile(
            title: Text(item),
            onTap: () {
              setState(() {
                controller.closeView(item);
              });
            },
          );
        });
      },
    );
  }
}
