import 'package:amathia/src/screens/home_page/pages/favorite_page/model/Favorite/Favorite.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FavoriteManager {
  final String userId;

  FavoriteManager(this.userId);

  // Carica i preferiti da Supabase
  Future<List<Favorite>> loadFavorites() async {
    final response = await Supabase.instance.client
        .from('favorites')
        .select()
        .eq('user_id', userId);


    final data = response as List<dynamic>;
    return data.map((item) => Favorite.fromJson(item)).toList();
  }

  // Aggiungi un preferito a Supabase
  Future<void> addFavorite(Favorite favorite) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null || user.id.isEmpty) {
      throw Exception('User not authenticated or user ID is null');
    } else {
      print("utente esiste");
    }
    final response = await Supabase.instance.client
        .from('favorites')
        .insert(favorite.toJson());

    if (response.error != null) {
      throw Exception('Failed to add favorite');
    }
  }

  // Rimuovi un preferito da Supabase
  Future<void> removeFavorite(String title) async {
    final response = await Supabase.instance.client
        .from('favorites')
        .delete()
        .eq('user_id', userId)
        .eq('title', title);

    if (response.error != null) {
      throw Exception('Failed to remove favorite');
    }
  }
}
