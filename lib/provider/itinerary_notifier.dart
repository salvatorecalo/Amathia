import 'package:amathia/main.dart';
import 'package:amathia/src/screens/home_page/pages/itinerari_page/model/itineraries.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ItineraryNotifier extends StateNotifier<List<Itinerary>> {
  final String userId;

  ItineraryNotifier(this.userId) : super([]);

  Future<List<Itinerary>> loadItineraries() async {
    final response = await supabase
        .from('itineraries')
        .select()
        .eq('user_id', userId);

    final itineraries = (response as List<dynamic>)
        .map((item) => Itinerary.fromJson(item))
        .toList();

    state = itineraries; // Aggiorna lo stato
    return itineraries; // Restituisci la lista
  }

  Future<void> addItinerary(Itinerary itinerary) async {
    await supabase.from('itineraries').insert(itinerary.toJson());
    state = [...state, itinerary];
  }

  Future<void> deleteItinerary(String id) async {
    await supabase.from('itineraries').delete().eq('id', id);
  }

  Future<void> updateItinerary(Itinerary itinerary) async {
    await supabase
        .from('itineraries')
        .update(itinerary.toJson())
        .eq('id', itinerary.id);
    state = [
      for (final it in state)
        if (it.id == itinerary.id) itinerary else it
    ];
  }
}
