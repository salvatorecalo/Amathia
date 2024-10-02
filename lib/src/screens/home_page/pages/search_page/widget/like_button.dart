import 'package:amathia/provider/favorite_provider.dart';
import 'package:amathia/src/screens/home_page/pages/favorite_page/model/Favorite/Favorite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LikeButton extends ConsumerWidget {
  final String itemId; // Identificativo unico dell'elemento
  final Map<String, dynamic> itemData; // Dati dell'elemento
  final String userId; // ID utente

  const LikeButton({
    super.key,
    required this.itemId,
    required this.itemData,
    required this.userId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Usa il provider con l'ID utente
    final favorites = ref.watch(favoriteProvider(userId));
    
    // Accedi al titolo usando la chiave 'title'
    final isLiked = favorites.any((item) => item.title == itemId); 

    Future<void> toggleLike() async {
      final notifier = ref.read(favoriteProvider(userId).notifier);
      if (isLiked) {
        await notifier.removeFavorite(itemId); // Rimuovi l'elemento dai preferiti
      } else {
        final favorite = Favorite.fromJson(itemData); // Crea un oggetto Favorite da itemData
        await notifier.addFavorite(favorite); // Aggiungi l'elemento ai preferiti
      }
    }

    return IconButton(
      icon: Icon(
        isLiked ? Icons.favorite : Icons.favorite_border,
        color: isLiked ? Colors.red : Colors.grey,
      ),
      onPressed: toggleLike,
    );
  }
}
