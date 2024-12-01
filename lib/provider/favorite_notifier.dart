import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:amathia/src/screens/home_page/pages/favorite_page/model/Favorite/Favorite.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
class FavoriteNotifier extends StateNotifier<List<Favorite>> {
  final String userId;

  FavoriteNotifier(this.userId) : super([]);

  // Carica i preferiti dall'API di Supabase
  Future<void> loadFavorites() async {
    final response = await Supabase.instance.client
        .from('favorites')
        .select()
        .eq('user_id', userId);

    final data = response as List<dynamic>;
    state = data.map((item) => Favorite.fromJson(item)).toList();
  }

  // Aggiungi un preferito
  Future<void> addFavorite(Favorite favorite) async {
    final response = await Supabase.instance.client
        .from('favorites')
        .insert(favorite.toJson());

    state = [...state, favorite];
  }

  // Rimuovi un preferito
  Future<void> removeFavorite(String title) async {
    final response = await Supabase.instance.client
        .from('favorites')
        .delete()
        .eq('user_id', userId)
        .eq('title', title);
    state = state.where((favorite) => favorite.title != title).toList();
  }
}
