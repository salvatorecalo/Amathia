import 'package:amathia/provider/itinerary_notifier.dart';
import 'package:amathia/src/screens/home_page/pages/itinerari_page/model/itineraries.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final itineraryProvider = StateNotifierProvider.family<ItineraryNotifier, List<Itinerary>, String>((ref, userId) {
  final notifier = ItineraryNotifier(userId);

  // Mantiene il provider attivo se necessario
  ref.onDispose(() {
    print("ItineraryProvider per $userId eliminato");
  });

  notifier.loadItineraries(); // Caricamento iniziale degli itinerari
  return notifier;
});
