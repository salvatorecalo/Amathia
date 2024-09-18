import 'dart:math';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/card/city_card.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/card/monument_card.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/card/nature_card.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/card/recipe_card.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/category_buttons.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/searchbar.dart';

extension LocalizationExtension on AppLocalizations {
  String? getString(String key) {
    final Map<String, String> localizedStrings = {
      'ricetteTitle1': ricetteTitle1,
      'ricetteTitle2': ricetteTitle2,
      'ricetteTitle3': ricetteTitle3,
      'borghiTitle1': borghiTitle1,
      'borghiTitle2': borghiTitle2,
      'borghiTitle3': borghiTitle3,
      'monumentiTitle1': monumentiTitle1,
      'monumentiTitle2': monumentiTitle2,
      'monumentiTitle3': monumentiTitle3,
      'naturaTitle1': naturaTitle1,
      'naturaTitle2': naturaTitle2,
      'naturaTitle3': naturaTitle3,
    };

    return localizedStrings[key];
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SupabaseClient client = Supabase.instance.client;
  final List<String> tables = ['Ricette', 'Borghi', 'Monumenti', 'Natura'];
  final Map<String, List<Widget>> fetchedData = {};
  bool isDataFetched = false;

  Future<void> fetchAllTables(AppLocalizations localizations) async {
    if (isDataFetched) return;

    for (String tableName in tables) {
      try {
        final response = await client.from(tableName).select("*");
        final data = response as List<dynamic>;

        final widgetGenerated = data.map<Widget>((e) {
          final title = e['title'] ?? localizations.titleNotAvailable;
          final image = client.storage.from(tableName).getPublicUrl(e['image']);
          final description =
              e['description'] ?? localizations.descriptionNotAvailable;
          final location = e['location'] ?? localizations.titleNotAvailable;

          if (tableName == "Ricette") {
            return Container(
              margin: const EdgeInsets.only(right: 10),
              child: RecipeCard(
                title: title,
                image: image,
                description: description,
                time: e['time'] ?? 2,
                peopleFor: e['peopleFor'] ?? 1,
                ingredients: List<String>.from(e['ingredients'] ?? []),
              ),
            );
          } else if (tableName == "Monumenti") {
            return Container(
              margin: const EdgeInsets.only(right: 10),
              child: MonumentsCard(
                location: location,
                image: image,
                title: title,
                description: description,
              ),
            );
          } else if (tableName == "Natura") {
            return Container(
              margin: const EdgeInsets.only(right: 10),
              child: NatureCard(
                location: location,
                image: image,
                title: title,
              ),
            );
          } else if (tableName == "Borghi") {
            return Container(
              margin: const EdgeInsets.only(right: 10),
              child: CityCard(
                description: description,
                image: image,
                title: title,
              ),
            );
          }
          return const SizedBox.shrink();
        }).toList();

        widgetGenerated.shuffle();
        setState(() {
          fetchedData[tableName] = widgetGenerated;
        });
      } catch (e, stacktrace) {
        print("Errore nella fetch della tabella $tableName: $e");
        print(stacktrace);
      }
    }

    setState(() {
      isDataFetched = true;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final localizations = AppLocalizations.of(context);
    if (localizations != null && !isDataFetched) {
      fetchAllTables(localizations);
    }
  }

  String getRandomTitle(AppLocalizations localizations, String tableName) {
    final randomIndex = Random().nextInt(3) + 1; // Genera numeri da 1 a 3
    final titleKey = '${tableName.toLowerCase()}Title$randomIndex';
    final title = localizations.getString(titleKey);

    // Debug prints per controllare la chiave e il valore del titolo
    print('Fetching title with key: $titleKey');
    print('Fetched title: $title');

    return title ?? localizations.titleNotAvailable;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

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
          if (!fetchedData.containsKey(table) || fetchedData[table]!.isEmpty) {
            return const SliverToBoxAdapter(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          return SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Text(
                    getRandomTitle(localizations!, table),
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
