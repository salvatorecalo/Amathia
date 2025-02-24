import 'dart:async';
import 'dart:math';
import 'package:amathia/provider/dark_theme_provider.dart';
import 'package:amathia/provider/itinerary_provider.dart';
import 'package:amathia/src/costants/costants.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/random_advice_group.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/searchbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/card/city_card.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/card/monument_card.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/card/nature_card.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/card/recipe_card.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/category_buttons.dart';
import 'package:url_launcher/url_launcher.dart';

extension LocalizationExtension on AppLocalizations {
  String? getString(String key) {
    final localizedStrings = {
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
  const SearchPage({super.key, required this.userId});

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
    if (isDataFetched || !mounted) return;

    for (String tableName in tables) {
      try {
        final response = await client.from(tableName).select("*");
        final data = response as List<dynamic>;
        final language = Localizations.localeOf(context).languageCode;

        final widgetGenerated = data.map<Widget>((e) {
          final title = e['title'] ?? localizations.titleNotAvailable;
          final image = client.storage.from(tableName).getPublicUrl(e['image']);
          final location = e['location'] ?? localizations.titleNotAvailable;
          final description =
              language == 'en' ? e['description_en'] : e['description_it'];

          switch (tableName) {
            case 'Ricette':
              return RecipeCard(
                itineraryId: e['uuid'],
                userId: widget.userId,
                title: title,
                image: image,
                description: description,
                time: e['time'],
                peopleFor: e['peoplefor'] ?? 1,
                ingredients:
                    List<String>.from(e['ingredients_${language}'] ?? []),
                type: tableName,
              );
            case 'Monumenti':
              return MonumentsCard(
                itineraryId: e['uuid'],
                userId: widget.userId,
                location: location,
                image: image,
                title: title,
                description: description,
                type: tableName,
              );
            case 'Natura':
              return NatureCard(
                itineraryId: e['uuid'],
                userId: widget.userId,
                location: location,
                image: image,
                title: title,
                description: description,
                type: tableName,
              );
            case 'Borghi':
              return CityCard(
                itineraryId: e['uuid'],
                userId: widget.userId,
                description: description,
                image: image,
                title: title,
                type: tableName,
              );
            default:
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
void didChangeDependencies() async {
  super.didChangeDependencies();
  
  final localizations = AppLocalizations.of(context);
  if (localizations != null && !isDataFetched) {
    fetchAllTables(localizations);
  }

  // Carica gli itinerari
  await ref.read(itineraryNotifierProvider(widget.userId).notifier).loadItineraries();
  
  // Ora puoi stampare le locations
  final itineraries = ref.read(itineraryNotifierProvider(widget.userId));
  print("Controlla locations: ${itineraries.map((itinerary) => itinerary.locations).toList()}");

  // Se è necessario fare qualcosa con gli itinerari caricati, fallo qui
}


  String getRandomTitle(AppLocalizations localizations, String tableName) {
    if (fetchedTitles.containsKey(tableName)) {
      return fetchedTitles[tableName]!;
    }

    final randomIndex = Random().nextInt(3) + 1;
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

    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverPadding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 18),
              sliver: SliverAppBar(
                toolbarHeight: 115,
                backgroundColor: isDark ? const Color(0x000000) : white,
                shadowColor: Colors.transparent,
                foregroundColor: Colors.transparent,
                flexibleSpace: GestureDetector(
                  onTap: () {
                    showSearch(
  context: context,
  delegate: CustomSearchDelegate(userId: widget.userId),
);

                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 20.0),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[900] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.search,
                            color: isDark ? Colors.white : Colors.black54),
                        const SizedBox(width: 10),
                        Text(
                          localizations!.search,
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black54,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 30),
                child: CategoryButtons(userId: widget.userId),
              ),
            ),
            ...tables.map((table) {
              if (!fetchedData.containsKey(table) ||
                  fetchedData[table]!.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: CircularProgressIndicator(color: blue),
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
                          const EdgeInsets.only(top: 20, bottom: 20, left: 18),
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
                    localizations.getInspired,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  RandomAdviceGroup(
                    itineraryId: fetchedData.values
                            .expand((list) => list)
                            .map((e) => (e as dynamic)
                                .itineraryId) // Cast dinamico per sicurezza
                            .firstOrNull ??
                        '',
                    widgetGenerated: fetchedData,
                    userId: widget.userId,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: TextButton(
                      onPressed: () {
                        launchUrl(Uri.parse('https://freepik.com'));
                      },
                      child: Text(localizations.copyright),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: TextButton(
                      onPressed: () {
                        launchUrl(Uri.parse('mailto:salvacalo.04@gmail.com'));
                      },
                      child: Text(localizations.contribuiteText),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
