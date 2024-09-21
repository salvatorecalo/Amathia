import 'package:amathia/provider/favorite_provider.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/like_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FavoritePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoriteProvider);
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations!.favoriteText),
        centerTitle: true,
      ),
      body: favorites.isEmpty // Controllo qui
          ? Center(
              child: Text(
                localizations.favoriteEmpty,
                textAlign: TextAlign.center,
              ), // Mostra il messaggio se vuoto
            )
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final favoriteItem = favorites[index];
                return Card(
                  child: ListTile(
                    leading: Image.network(
                      favoriteItem['image'], // Immagine dell'elemento
                    ),
                    title: Text(favoriteItem['title']),
                    subtitle: Text(favoriteItem['description']),
                    trailing: LikeButton(
                      itemId: favoriteItem['title'], // ID unico
                      itemData: favoriteItem, // Dati dell'elemento
                    ),
                  ),
                );
              },
            ),
    );
  }
}
