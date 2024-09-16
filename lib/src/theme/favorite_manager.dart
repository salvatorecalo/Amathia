import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoriteManager {
  static const String favoritesKey = 'favorites';

  // Recupera tutti i preferiti
  static Future<List<Map<String, dynamic>>> getFavorites() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? favoritesString = prefs.getString(favoritesKey);

    if (favoritesString != null) {
      try {
        final List<dynamic> favoritesJson = jsonDecode(favoritesString);
        return favoritesJson.cast<Map<String, dynamic>>();
      } catch (e) {
        print("Error parsing favorites: $e");
        return [];
      }
    }

    return [];
  }

  // Aggiunge un preferito
  static Future<void> addFavorite(Map<String, dynamic> favorite) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> currentFavorites = await getFavorites();

    // Controlla se il preferito esiste già
    final isAlreadyFavorite =
        currentFavorites.any((item) => item['title'] == favorite['title']);
    if (!isAlreadyFavorite) {
      currentFavorites.add(favorite);
      await prefs.setString(favoritesKey, jsonEncode(currentFavorites));
    }
  }

  // Rimuove un preferito
  static Future<void> removeFavorite(String title) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> currentFavorites = await getFavorites();

    // Filtra i preferiti rimuovendo l'elemento con il titolo corrispondente
    currentFavorites.removeWhere((item) => item['title'] == title);
    await prefs.setString(favoritesKey, jsonEncode(currentFavorites));
  }

  // Verifica se un elemento è tra i preferiti
  static Future<bool> isFavorite(String title) async {
    final List<Map<String, dynamic>> currentFavorites = await getFavorites();
    return currentFavorites.any((item) => item['title'] == title);
  }
}
