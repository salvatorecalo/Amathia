import 'package:amathia/provider/itinerary_notifier.dart';
import 'package:amathia/src/screens/home_page/pages/itinerari_page/model/itineraries.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Definisci il provider come family
final itineraryNotifierProvider = StateNotifierProvider.family<ItineraryNotifier, List<Itinerary>, String>(
  (ref, userId) => ItineraryNotifier(userId),
);
