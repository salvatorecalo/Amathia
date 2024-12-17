import 'package:amathia/provider/itinerary_notifier.dart';
import 'package:amathia/src/screens/home_page/pages/itinerari_page/model/itineraries.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final itineraryNotifierProvider = StateNotifierProvider<ItineraryNotifier, List<Itinerary>>((ref) {
  final userId = "user123"; // Recupera lo userId dinamicamente se possibile
  return ItineraryNotifier(userId);
});
