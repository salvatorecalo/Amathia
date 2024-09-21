import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoriteManager {
  static const String favoritesKey = 'favorites';

  static Future<List<Map<String, dynamic>>> getFavorites() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? favoritesString = prefs.getString(favoritesKey);
    if (favoritesString != null) {
      return List<Map<String, dynamic>>.from(json.decode(favoritesString));
    }
    return [];
  }

  static Future<void> addFavorite(Map<String, dynamic> favorite) async {
    final favorites = await getFavorites();
    favorites.add(favorite);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(favoritesKey, json.encode(favorites));
  }

  static Future<void> removeFavorite(String title) async {
    final favorites = await getFavorites();
    favorites.removeWhere((item) => item['title'] == title);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(favoritesKey, json.encode(favorites));
  }
}

class FavoriteNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  FavoriteNotifier() : super([]) {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    state = await FavoriteManager.getFavorites();
  }

  Future<void> addFavorite(Map<String, dynamic> favorite) async {
    await FavoriteManager.addFavorite(favorite);
    await _loadFavorites();
  }

  Future<void> removeFavorite(String title) async {
    await FavoriteManager.removeFavorite(title);
    await _loadFavorites();
  }
}

final favoriteProvider =
    StateNotifierProvider<FavoriteNotifier, List<Map<String, dynamic>>>(
  (ref) => FavoriteNotifier(),
);
