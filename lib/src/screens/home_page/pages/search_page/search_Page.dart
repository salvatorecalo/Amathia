import 'dart:async';
import 'dart:math';
import 'package:amathia/provider/dark_theme_provider.dart';
import 'package:amathia/src/costants/costants.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/random_advice_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/card/city_card.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/card/monument_card.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/card/nature_card.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/card/recipe_card.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/category_buttons.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/searchbar.dart';
import 'package:url_launcher/url_launcher.dart';

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

class SearchPage extends ConsumerStatefulWidget {
  final String userId;
  const SearchPage({
    super.key,
    required this.userId,
  });

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final SupabaseClient client = Supabase.instance.client;
  final List<String> tables = ['Ricette', 'Borghi', 'Monumenti', 'Natura'];
  final Map<String, List<Widget>> fetchedData = {};
  final Map<String, String> fetchedTitles = {};
  bool isDataFetched = false;

  Future<void> fetchAllTables(AppLocalizations localizations) async {
    if (isDataFetched) return;
    if (!mounted) return;
    for (String tableName in tables) {
      try {
        final response = await client.from(tableName).select("*");
        final data = response as List<dynamic>;
        String language = Localizations.localeOf(context).languageCode;
        final widgetGenerated = data.map<Widget>((e) {
          final title = e['title'] ?? localizations.titleNotAvailable;
          final image = client.storage.from(tableName).getPublicUrl(e['image']);
          final location = e['location'] ?? localizations.titleNotAvailable;

          if (language == 'en') {
            if (tableName == "Ricette") {
              return Container(
                margin: const EdgeInsets.only(right: 10),
                child: RecipeCard(
                  userId: widget.userId,
                  title: title,
                  image: image,
                  description: e['description_en'],
                  time: e['time'],
                  peopleFor: e['peoplefor'] ?? 1,
                  ingredients: List<String>.from(e['ingredients_en'] ?? []),
                ),
              );
            } else if (tableName == "Monumenti") {
              return Container(
                margin: const EdgeInsets.only(right: 10),
                child: MonumentsCard(
                  userId: widget.userId,
                  location: location,
                  image: image,
                  title: title,
                  description: e['description_en'],
                ),
              );
            } else if (tableName == "Natura") {
              return Container(
                margin: const EdgeInsets.only(right: 10),
                child: NatureCard(
                    userId: widget.userId,
                    location: location,
                    image: image,
                    title: title,
                    description: e['description_en']),
              );
            } else if (tableName == "Borghi") {
              print("itinery id city card: ${e['uuid']}");
              return Container(
                margin: const EdgeInsets.only(right: 10),
                child: CityCard(
                  userId: widget.userId,
                  itineraryId: e['uuid'], // uuid is the unique id for itinerary
                  description: e['description_en'],
                  image: image,
                  title: title,
                ),
              );
            }
            return const SizedBox.shrink();
          } else {
            if (tableName == "Ricette") {
              return Container(
                margin: const EdgeInsets.only(right: 10),
                child: RecipeCard(
                  userId: widget.userId,
                  title: title,
                  image: image,
                  description: e['description_it'],
                  time: e['time'],
                  peopleFor: e['peoplefor'] ?? 1,
                  ingredients: List<String>.from(e['ingredients_it'] ?? []),
                ),
              );
            } else if (tableName == "Monumenti") {
              return Container(
                margin: const EdgeInsets.only(right: 10),
                child: MonumentsCard(
                  userId: widget.userId,
                  location: location,
                  image: image,
                  title: title,
                  description: e['description_it'],
                ),
              );
            } else if (tableName == "Natura") {
              return Container(
                margin: const EdgeInsets.only(right: 10),
                child: NatureCard(
                  userId: widget.userId,
                  location: location,
                  image: image,
                  title: title,
                  description: e['description_it'],
                ),
              );
            } else if (tableName == "Borghi") {
              print("pippo fa le seghe ${e['uuid']}");
              return Container(
                margin: const EdgeInsets.only(right: 10),
                child: CityCard(
                  itineraryId: e['uuid'],
                  userId: widget.userId,
                  description: e['description_it'],
                  image: image,
                  title: title,
                ),
              );
            }
            return const SizedBox.shrink();
          }
        }).toList();

        widgetGenerated.shuffle();
        if (mounted) {
          setState(() {
            fetchedData[tableName] = widgetGenerated;
          });
        }
      } catch (e, stacktrace) {
        print("Errore nella fetch della tabella $tableName: $e");
        print(stacktrace);
      }
    }

    if (mounted) {
      setState(() {
        isDataFetched = true;
      });
    }
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
    // Se il titolo è già stato fetchato, restituiscilo
    if (fetchedTitles.containsKey(tableName)) {
      return fetchedTitles[tableName]!;
    }

    // Altrimenti genera un nuovo titolo casuale
    final randomIndex = Random().nextInt(3) + 1; // Genera numeri da 1 a 3
    final titleKey = '${tableName.toLowerCase()}Title$randomIndex';
    final title =
        localizations.getString(titleKey) ?? localizations.titleNotAvailable;

    fetchedTitles[tableName] = title;

    return title;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final isDark = ref.watch(darkThemeProvider);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 18),
            sliver: SliverAppBar(
              toolbarHeight: 115,
              flexibleSpace: SearchDropdown(
                userId: widget.userId,
              ),
              backgroundColor: isDark ? const Color(0x000000) : white,
              shadowColor: Colors.transparent,
              foregroundColor: Colors.transparent,
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 30),
              child: CategoryButtons(
                userId: widget.userId,
              ),
            ),
          ),
          ...tables.map((table) {
            if (!fetchedData.containsKey(table) ||
                fetchedData[table]!.isEmpty) {
              return const SliverToBoxAdapter(
                child: Center(
                  child: CircularProgressIndicator(
                    color: blue,
                  ),
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
                    margin:
                        const EdgeInsets.only(left: 18, top: 20, bottom: 20),
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
          SliverToBoxAdapter(
            child: Column(
              children: [
                Text(
                  localizations!.getInspired,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                RandomAdviceGroup(
                  widgetGenerated: fetchedData,
                  userId: widget.userId,
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 10,
                  ),
                  child: TextButton(
                    onPressed: () {
                      launchUrl(
                        Uri.parse('https://freepik.com'),
                      );
                    },
                    child: Text(localizations.copyright),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
