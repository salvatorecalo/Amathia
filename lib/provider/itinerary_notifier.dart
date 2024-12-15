import 'package:amathia/main.dart';
import 'package:amathia/src/screens/home_page/pages/itinerari_page/model/itineraries.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ItineraryNotifier extends StateNotifier<List<Itinerary>> {
  final String userId;

  ItineraryNotifier(this.userId) : super([]);

  // Carica gli itinerari per l'utente con gestione errori
  Future<List<Itinerary>> loadItineraries() async {
    try {
      final response = await supabase
          .from('itineraries')
          .select()
          .eq('user_id', userId);

      if (response is List<dynamic>) {
        final itineraries = response
            .map((item) => Itinerary.fromJson(item))
            .toList();
        state = itineraries;
        return itineraries;
      } else {
        throw Exception('Formato risposta inaspettato');
      }
    } catch (error) {
      print("Errore durante il caricamento degli itinerari: $error");
      state = []; // Stato vuoto in caso di errore
      return [];
    }
  }

  // Aggiungi un nuovo itinerario con gestione errori
  Future<void> addItinerary(Itinerary itinerary) async {
    try {
      await supabase.from('itineraries').insert(itinerary.toJson());
      state = [...state, itinerary]; // Aggiorna lo stato locale
    } catch (error) {
      print("Errore durante l'aggiunta dell'itinerario: $error");
    }
  }

  // Elimina un itinerario con gestione errori
  Future<void> deleteItinerary(String id) async {
    try {
      await supabase.from('itineraries').delete().eq('id', id);
      state = state.where((itinerary) => itinerary.id != id).toList(); // Rimuovi dallo stato locale
    } catch (error) {
      print("Errore durante l'eliminazione dell'itinerario: $error");
    }
  }

  // Aggiorna un itinerario esistente con gestione errori
  Future<void> updateItinerary(Itinerary itinerary) async {
    try {
      await supabase
          .from('itineraries')
          .update(itinerary.toJson())
          .eq('id', itinerary.id);

      state = [
        for (final it in state)
          if (it.id == itinerary.id) itinerary else it
      ]; // Aggiorna l'elemento nello stato locale
    } catch (error) {
      print("Errore durante l'aggiornamento dell'itinerario: $error");
    }
  }
}
