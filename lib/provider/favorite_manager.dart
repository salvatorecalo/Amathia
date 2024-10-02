import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:amathia/src/screens/home_page/pages/favorite_page/model/Favorite/Favorite.dart';

class FavoriteManager extends ChangeNotifier {
  static const String favoritesKey = 'favorites';

  final String userId;  // L'ID univoco dell'utente
  List<Favorite> favorites = [];  // Lista dei preferiti

  FavoriteManager(this.userId);

  // Carica i preferiti specifici per l'utente da SharedPreferences
  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favoritesString = prefs.getString('${favoritesKey}_$userId'); // Chiave specifica per l'utente

    if (favoritesString != null) {
      List<dynamic> jsonData = json.decode(favoritesString);
      favorites = jsonData.map((item) => Favorite.fromJson(item)).toList();
    } else {
      favorites = [];  // Se non ci sono preferiti, inizia con una lista vuota
    }
    notifyListeners();
  }

  // Aggiungi un preferito e salva i dati
  Future<void> addFavorite(Favorite favorite) async {
    favorites.add(favorite);
    await saveFavorites();  // Salva i preferiti dopo aver aggiunto uno nuovo
  }

  // Rimuovi un preferito e salva i dati
  Future<void> removeFavorite(String title) async {
    favorites.removeWhere((favorite) => favorite.title == title);
    await saveFavorites();  // Salva i preferiti dopo la rimozione
  }

  // Salva i preferiti dell'utente in SharedPreferences
  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('${favoritesKey}_$userId', json.encode(favorites)); // Usa chiave con userId
  }
}
