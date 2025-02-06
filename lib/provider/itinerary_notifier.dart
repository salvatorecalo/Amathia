import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:amathia/src/screens/home_page/pages/itinerari_page/model/itineraries.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class ItineraryNotifier extends StateNotifier<List<Itinerary>> {
  final String userId;

  ItineraryNotifier(this.userId) : super([]);

  Future<void> loadItineraries() async {
  try {
    final response = await Supabase.instance.client
        .from('itineraries')
        .select()
        .eq('userId', userId);

    print("Risposta itinerary supabase $response");
    print("user id dopo risposta itinerari $userId");
    
    // Se ci sono risposte
    if (response.isNotEmpty) {
      // Itera sulla risposta e stampa ogni campo
      for (var data in response) {
        print("Data: $data");
        print("ID: ${data['id']}");
        print("UserId: ${data['userId']}");
        print("Title: ${data['title']}");
        print("Locations: ${data['locations']}");
        print("Created At: ${data['created_at']}");
      }

      // Mappa la risposta agli oggetti Itinerary
      List<Itinerary> itineraries = response.map((data) {
        // Gestisci il tipo di locations come List<Map<String, dynamic>>
        List<Map<String, dynamic>> locations = List<Map<String, dynamic>>.from(data['locations'] ?? []);
        
        final String id = data['id'] ?? 'null';
        final String title = data['title'] ?? 'Untitled';
        final String createdAt = data['created_at'] ?? 'Unknown Date';

        // Stampa i valori verificati
        print("Itinerary (ID: $id) - Title: $title - Locations: $locations");

        // Crea e restituisci l'oggetto Itinerary
        return Itinerary(
          id: id,
          userId: userId,
          title: title,
          locations: locations,
          type: 'Trip',
        );
      }).toList();

      // Aggiorna lo stato
      state = itineraries;
    } else {
      print('Nessun itinerario trovato.');
    }
  } catch (e) {
    print('Errore nel caricamento degli itinerari: $e');
  }
}
  Future<void> addItinerary(Itinerary itinerary) async {
  try {
    // Verifica se l'ID è vuoto e, in caso affermativo, genera un nuovo UUID
    final String id = itinerary.id.isEmpty ? Uuid().v4() : itinerary.id;

    print("Itinerary ID: $id");
    
    final response = await Supabase.instance.client.from('itineraries').insert({
      'id': id,
      'userId': userId,
      'title': itinerary.title,
      'locations': itinerary.locations,
      'created_at': DateTime.now().toIso8601String(),
    }).select();

    if (response.isNotEmpty) {
      state = [...state, Itinerary.fromJson(response.first)];
    }
  } catch (e) {
    print('Errore nel salvataggio: $e');
  }
}


  Future<void> updateItinerary(Itinerary updatedItinerary) async {
    try {
      await Supabase.instance.client.from('itineraries').update({
        'title': updatedItinerary.title,
        'locations': updatedItinerary.locations,
      }).eq('id', updatedItinerary.id);

      state = state
          .map((it) => it.id == updatedItinerary.id ? updatedItinerary : it)
          .toList();
    } catch (e) {
      print('Errore nell’aggiornamento: $e');
    }
  }

  Future<void> deleteItinerary(String id) async {
    try {
      await Supabase.instance.client.from('itineraries').delete().eq('id', id);

      state = state.where((it) => it.id != id).toList();
    } catch (e) {
      print('Errore nell’eliminazione: $e');
    }
  }

  Future<void> addItemToItinerary(String id, Map<String, dynamic> item) async {
    try {
      state = state.map((itinerary) {
        if (itinerary.id == id) {
          final updatedItinerary =
              itinerary.copyWith(locations: [...itinerary.locations, item]);

          Supabase.instance.client
              .from('itineraries')
              .update({'locations': updatedItinerary.locations})
              .eq('id', id);

          return updatedItinerary;
        }
        return itinerary;
      }).toList();
    } catch (e) {
      print('Errore nell’aggiunta dell’elemento: $e');
    }
  }

  Future<void> removeItemFromItinerary(String id, Map<String, dynamic> item) async {
    try {
      state = state.map((itinerary) {
        if (itinerary.id == id) {
          final updatedItinerary = itinerary.copyWith(
            locations: itinerary.locations
                .where((location) => location['id'] != item['id'])
                .toList(),
          );

          Supabase.instance.client
              .from('itineraries')
              .update({'locations': updatedItinerary.locations})
              .eq('id', id);

          return updatedItinerary;
        }
        return itinerary;
      }).toList();
    } catch (e) {
      print('Errore nella rimozione dell’elemento: $e');
    }
  }
}