import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:amathia/src/screens/home_page/pages/favorite_page/model/Favorite/Favorite.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoriteNotifier extends StateNotifier<List<Favorite>> {
  final String userId;

  FavoriteNotifier(this.userId) : super([]);

  // Carica i preferiti dell'utente al momento della creazione
  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favoritesString = prefs.getString('favorites_$userId'); // Chiave specifica per l'utente

    if (favoritesString != null) {
      List<dynamic> jsonData = json.decode(favoritesString);
      state = jsonData.map((item) => Favorite.fromJson(item)).toList();
    }
  }

  // Aggiungi un preferito e salva la lista aggiornata
  Future<void> addFavorite(Favorite favorite) async {
    state = [...state, favorite];
    await saveFavorites();
  }

  // Rimuovi un preferito e salva la lista aggiornata
  Future<void> removeFavorite(String title) async {
    state = state.where((favorite) => favorite.title != title).toList();
    await saveFavorites();
  }

  // Salva i preferiti in SharedPreferences
  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('favorites_$userId', json.encode(state));
  }
}

// Provider familiare che accetta un userId e fornisce i preferiti specifici per l'utente
final favoriteProvider = StateNotifierProvider.family<FavoriteNotifier, List<Favorite>, String>(
  (ref, userId) => FavoriteNotifier(userId)..loadFavorites(),
);
