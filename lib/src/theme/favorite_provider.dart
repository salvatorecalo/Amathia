import 'package:flutter/material.dart';
import 'favorite_manager.dart'; // importa il FavoriteManager

class FavoriteProvider with ChangeNotifier {
  List<Map<String, dynamic>> _favorites = [];

  List<Map<String, dynamic>> get favorites => _favorites;

  FavoriteProvider() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    _favorites = await FavoriteManager.getFavorites();
    notifyListeners(); // Notifica gli ascoltatori che ci sono nuovi dati
  }

  Future<void> addFavorite(Map<String, dynamic> favorite) async {
    await FavoriteManager.addFavorite(favorite);
    await _loadFavorites(); // Ricarica i preferiti e notifica
  }

  Future<void> removeFavorite(String title) async {
    await FavoriteManager.removeFavorite(title);
    await _loadFavorites(); // Ricarica i preferiti e notifica
  }

  bool isFavorite(String title) {
    return _favorites.any((item) => item['title'] == title);
  }
}
