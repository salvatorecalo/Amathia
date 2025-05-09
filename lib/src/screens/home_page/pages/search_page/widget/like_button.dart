import 'package:amathia/provider/favorite_provider.dart';
import 'package:amathia/src/screens/home_page/pages/favorite_page/model/Favorite/Favorite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LikeButton extends ConsumerWidget {
  final String itemId;
  final Map<String, dynamic> itemData; 

  const LikeButton({
    super.key,
    required this.itemId,
    required this.itemData,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoriteProvider(itemData['userId']));
    
    final isLiked = favorites.any((item) => item.title == itemId); 

    Future<void> toggleLike() async {
      final notifier = ref.read(favoriteProvider(itemData['userId']).notifier);
      if (isLiked) {
        await notifier.removeFavorite(itemId); 
      } else {
        final favorite = Favorite.fromJson(itemData); 
        await notifier.addFavorite(favorite); 
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
