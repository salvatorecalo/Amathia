import 'package:amathia/provider/favorite_notifier.dart';
import 'package:amathia/src/screens/home_page/pages/favorite_page/model/Favorite/Favorite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favoriteProvider = StateNotifierProvider.family<FavoriteNotifier, List<Favorite>, String>(
  (ref, userId) => FavoriteNotifier(userId)..loadFavorites(),
);
