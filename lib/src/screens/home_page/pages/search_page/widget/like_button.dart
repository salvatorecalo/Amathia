import 'package:amathia/src/theme/favorite_manager.dart';
import 'package:flutter/material.dart';

class LikeButton extends StatefulWidget {
  final String itemId;
  final Map<String, dynamic> itemData;
  final bool initialState;
  final String cardType;

  const LikeButton({
    super.key,
    required this.itemId,
    required this.itemData,
    required this.initialState,
    required this.cardType,
  });

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  late bool isLiked;

  @override
  void initState() {
    super.initState();
    isLiked = widget
        .initialState; // Initialize with initial state (from favorite check)
  }

  Future<void> _toggleLike() async {
    setState(() {
      isLiked = !isLiked;
    });

    try {
      if (isLiked) {
        // Add to favorites
        await FavoriteManager.addFavorite(widget.itemData);
      } else {
        // Remove from favorites
        await FavoriteManager.removeFavorite(widget.itemId);
      }
    } catch (e) {
      // Handle any error and revert the UI state
      setState(() {
        isLiked = !isLiked; // Revert the change if there was an error
      });
      print("Error updating favorites: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isLiked ? Icons.favorite : Icons.favorite_border,
        color: isLiked ? Colors.red : Colors.grey,
      ),
      onPressed: _toggleLike, // Toggle the like status when pressed
    );
  }
}
