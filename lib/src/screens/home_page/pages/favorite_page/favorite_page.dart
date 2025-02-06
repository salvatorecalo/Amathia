import 'package:amathia/provider/favorite_provider.dart';
import 'package:amathia/src/screens/home_page/pages/favorite_page/widget/filter_button.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/opened/city_card_open.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/opened/monument_card_open.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/opened/nature_card_open.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/opened/recipe_card_open.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/like_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FavoritePage extends ConsumerStatefulWidget {
  final String userId; // Passa l'ID utente come argomento
  const FavoritePage({
    super.key,
    required this.userId,
  }); // Aggiungi userId al costruttore

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends ConsumerState<FavoritePage> {
  String selectedCategory = 'All';

  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Carica i preferiti ogni volta che la pagina viene visualizzata
    if (!_isInitialized) {
      _isInitialized = true; // Evita chiamate multiple in caso di rebuild
    } else {
      _loadFavorites();
    }
  }

  void _loadFavorites() async {
    try {
      await ref.read(favoriteProvider(widget.userId).notifier).loadFavorites();
    } catch (e) {
      debugPrint("Errore durante il caricamento dei preferiti: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final favorites = ref.watch(favoriteProvider(widget.userId));
    final localizations = AppLocalizations.of(context);

    // Filtra i preferiti in base alla categoria selezionata
    final filteredFavorites = selectedCategory == 'All'
        ? favorites
        : favorites.where((item) {
            return item.type == selectedCategory;
          }).toList();
    print("Filtered favorites $favorites");
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                localizations!.favoriteText,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            // Bottoni di filtro
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterButton(
                      text: localizations.all,
                      isSelected: selectedCategory == 'All',
                      onTap: () {
                        setState(() {
                          selectedCategory = 'All';
                        });
                      },
                    ),
                    FilterButton(
                      text: 'Borghi',
                      isSelected: selectedCategory == 'Borghi',
                      onTap: () {
                        setState(() {
                          selectedCategory = 'Borghi';
                        });
                      },
                    ),
                    FilterButton(
                      text: 'Monumenti',
                      isSelected: selectedCategory == 'Monumenti',
                      onTap: () {
                        setState(() {
                          selectedCategory = 'Monumenti';
                        });
                      },
                    ),
                    FilterButton(
                      text: 'Ricette',
                      isSelected: selectedCategory == 'Ricette',
                      onTap: () {
                        setState(() {
                          selectedCategory = 'Ricette';
                        });
                      },
                    ),
                    FilterButton(
                      text: 'Natura',
                      isSelected: selectedCategory == 'Natura',
                      onTap: () {
                        setState(() {
                          selectedCategory = 'Natura';
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            // Lista dei preferiti filtrati
            Expanded(
              child: filteredFavorites.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/no_favorite.png',
                            width: 200,
                          ),
                          Text(
                            localizations.favoriteEmpty,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredFavorites.length,
                      itemBuilder: (context, index) {
                        final favoriteItem = filteredFavorites[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                if (favoriteItem.type == 'Ricette') {
                                  return RecipeOpenCard(
                                    itineraryId: '',
                                    title: favoriteItem.title,
                                    userId: widget.userId,
                                    description: favoriteItem.description,
                                    image: favoriteItem.image,
                                    peopleFor: favoriteItem.peoplefor ?? 1,
                                    time: favoriteItem.time.toString(),
                                    ingredients: favoriteItem.ingredients ?? [],
                                  );
                                } else if (favoriteItem.type == 'Borghi') {
                                  return CityOpenCard(
                                    itineraryId: '',
                                    userId: widget.userId,
                                    title: favoriteItem.title,
                                    description: favoriteItem.description,
                                    image: favoriteItem.image,
                                  );
                                } else if (favoriteItem.type == 'Monumenti') {
                                  return MonumentOpenCard(
                                    itineraryId: favoriteItem.title,
                                    userId: widget.userId,
                                    title: favoriteItem.title,
                                    location: favoriteItem.location!,
                                    description: favoriteItem.description,
                                    image: favoriteItem.image,
                                  );
                                } else if (favoriteItem.type == 'Natura') {
                                  return NatureOpenCard(
                                    itineraryId: '',
                                    userId: widget.userId,
                                    title: favoriteItem.title,
                                    location: favoriteItem.location!,
                                    description: favoriteItem.description,
                                    image: favoriteItem.image,
                                  );
                                }
                                return const SizedBox.shrink();
                              }),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.all(15),
                            child: Column(
                              children: [
                                SizedBox(
                                  width: double
                                      .infinity, // La larghezza occupa tutta la carta
                                  height:
                                      100, // Impostiamo l'altezza massima dell'immagine a 300px
                                  child: Image.network(
                                    favoriteItem.image,
                                    fit: BoxFit
                                        .cover, // L'immagine si adatta mantenendo il giusto rapporto
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(left: 40),
                                      child: Text(
                                        favoriteItem.title,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(right: 40),
                                      child: LikeButton(
                                        itemId: favoriteItem.title,
                                        itemData: favoriteItem.toJson(),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
