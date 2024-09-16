import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/card/city_card.dart';
import 'package:amathia/src/theme/favorite_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteProvider>(
      builder: (context, favoriteProvider, child) {
        final favorites = favoriteProvider.favorites;

        if (favorites.isEmpty) {
          return const Center(child: Text('No favorites found.'));
        }

        return Column(
          children: [
            Container(
              margin: const EdgeInsets.only(
                top: 25,
              ),
              child: const Text(
                "I tuoi preferiti",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final favorite = favorites[index];
                  return Container(
                    margin: const EdgeInsets.all(20),
                    child: CityCard(
                      title: favorite['title'] ?? 'No title',
                      image: favorite['image'] ?? '',
                      description: favorite['description'] ?? 'No description',
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
