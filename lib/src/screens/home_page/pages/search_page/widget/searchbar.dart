import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchBarApp extends StatefulWidget {
  const SearchBarApp({super.key});

  @override
  State<SearchBarApp> createState() => _SearchBarAppState();
}

class _SearchBarAppState extends State<SearchBarApp> {
  final supabase = Supabase.instance.client;
  final SearchController _searchController = SearchController();
  List<Map<String, dynamic>> searchResults = [];
  bool isLoading = false;

  Future<void> _search(String query) async {
    print("Searching for: $query");
    setState(() {
      isLoading = true;
    });

    final ricetteResponse =
        await supabase.from('Ricette').select().ilike('title', '%$query%');
    print("Ricette response: $ricetteResponse");

    final monumentiResponse =
        await supabase.from('Monumenti').select().ilike('title', '%$query%');
    print("Monumenti response: $monumentiResponse");

    final naturaResponse =
        await supabase.from('Natura').select().ilike('title', '%$query%');
    print("Natura response: $naturaResponse");

    final borghiResponse =
        await supabase.from('Borghi').select().ilike('title', '%$query%');
    print("Borghi response: $borghiResponse");

    setState(() {
      searchResults = [
        ...ricetteResponse.map((e) => {'type': 'Ricetta', 'data': e}),
        ...monumentiResponse.map((e) => {'type': 'Monumento', 'data': e}),
        ...naturaResponse.map((e) => {'type': 'Natura', 'data': e}),
        ...borghiResponse.map((e) => {'type': 'Borgo', 'data': e}),
      ];
      isLoading = false;
    });

    if (searchResults.isEmpty) {
      print("No results found");
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return SearchAnchor(
      builder: (BuildContext context, SearchController controller) {
        return SearchBar(
          hintText: localizations!.searchText,
          controller: _searchController,
          padding: const WidgetStatePropertyAll<EdgeInsets>(
              EdgeInsets.symmetric(horizontal: 16.0)),
          onTap: () {
            controller.openView();
            print("SearchBar tapped");
          },
          onChanged: (query) {
            print("Search query changed: $query");
            _search(query);
          },
          leading: const Icon(Icons.search),
        );
      },
      suggestionsBuilder: (BuildContext context, SearchController controller) {
        if (isLoading) {
          print("Loading...");
          return [const Center(child: CircularProgressIndicator())];
        }

        print("Search results: $searchResults");
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
