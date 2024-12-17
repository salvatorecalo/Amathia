import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:amathia/src/screens/home_page/pages/itinerari_page/model/itineraries.dart';

class ItineraryNotifier extends StateNotifier<List<Itinerary>> {
  final String userId;

  ItineraryNotifier(this.userId) : super([]) {
    loadItineraries(); // Carica i dati iniziali
  }

  // Metodo per caricare gli itinerari (dovrebbe chiamare una sorgente dati esterna)
  Future<void> loadItineraries() async {
    try {
      // Simulazione: carica dati iniziali
      final dummyItineraries = [
        Itinerary(id: '1', userId: userId, title: 'Itinerario 1', locations: []),
        Itinerary(id: '2', userId: userId, title: 'Itinerario 2', locations: []),
      ];
      state = dummyItineraries;
    } catch (e) {
      // Puoi aggiungere gestione degli errori
      print('Errore nel caricamento: $e');
    }
  }

  // Aggiunge un nuovo itinerario
  Future<void> addItinerary(Itinerary itinerary) async {
    state = [...state, itinerary]; // Aggiunge alla lista esistente
  }

  // Modifica un itinerario
  Future<void> updateItinerary(Itinerary updatedItinerary) async {
    state = state.map((it) {
      return it.id == updatedItinerary.id ? updatedItinerary : it;
    }).toList();
  }

  // Elimina un itinerario
  Future<void> deleteItinerary(String id) async {
    state = state.where((it) => it.id != id).toList();
  }

  // Aggiunge un elemento all'itinerario
  Future<void> addItemToItinerary(String itineraryId, Map<String, dynamic> item) async {
    state = state.map((itinerary) {
      if (itinerary.id == itineraryId) {
        return itinerary.copyWith(locations: [...itinerary.locations, item]);
      }
      return itinerary;
    }).toList();
  }

  // Rimuove un elemento dall'itinerario
  Future<void> removeItemFromItinerary(String itineraryId, Map<String, dynamic> item) async {
    state = state.map((itinerary) {
      if (itinerary.id == itineraryId) {
        return itinerary.copyWith(
          locations: itinerary.locations.where((location) => location != item).toList(),
        );
      }
      return itinerary;
    }).toList();
  }

}
