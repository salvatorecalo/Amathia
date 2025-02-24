import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:amathia/src/screens/home_page/pages/itinerari_page/model/itineraries.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class ItineraryNotifier extends StateNotifier<List<Itinerary>> {
  final String userId;

  ItineraryNotifier(this.userId) : super([]);
Future<void> loadItineraries() async {
  final response = await Supabase.instance.client
      .from('itineraries')
      .select()
      .eq('userId', userId);

  final data = response as List<dynamic>;

  print("📥 Dati ricevuti da Supabase: $data");

  state = data.map((item) {
    return Itinerary.fromJson({
      ...item,
      'locations': item['locations'] ?? [], // Assicura che locations non sia null
    });
  }).toList();

  print("✅ Stato aggiornato con itinerari: $state");
}


Future<void> addItinerary(Itinerary itinerary) async {
  try {
    final String id = itinerary.id.isEmpty ? Uuid().v4() : itinerary.id;
    final response = await Supabase.instance.client
        .from('itineraries')
        .insert({
          'id': id,
          'userId': userId,
          'title': itinerary.title,
          'locations': itinerary.locations,
          'created_at': DateTime.now().toIso8601String(),
        })
        .select();

    if (response.isNotEmpty) {
      state = [...state, Itinerary.fromJson(response.first)];
    }
  } catch (e) {
    print('Errore nel salvataggio: $e');
  }
}


  // Rimuovi un itinerario
  Future<void> removeItinerary(String id) async {
    try {
      await Supabase.instance.client
          .from('itineraries')
          .delete()
          .eq('id', id);

      state = state.where((itinerary) => itinerary.id != id).toList();
    } catch (e) {
      print('Errore nella rimozione dell’itinerario: $e');
    }
  }

  // Rinomina un itinerario
  Future<void> renameItinerary(String id, String newTitle) async {
    try {
      print("Itinerary: ${id}, newTitle: ${newTitle}");
      final response = await Supabase.instance.client
          .from('itineraries')
          .update({'title': newTitle})
          .eq('id', id);
        state = state.map((itinerary) {
          if (itinerary.id == id) {
            return itinerary.copyWith(title: newTitle);
          }
          return itinerary;
        }).toList();
    } catch (e) {
      print('Errore nel rinominare l’itinerario: $e');
    }
  }
Future<void> addItemToItinerary(String id, Map<String, dynamic> item) async {
  try {
    // 🔹 Recupera l'itinerario attuale da Supabase per ottenere locations aggiornato
    final response = await Supabase.instance.client
        .from('itineraries')
        .select('locations')
        .eq('id', id)
        .single();

    if (response == null || !response.containsKey('locations')) {
      print("❌ Errore: Nessuna locations trovata per l'itinerario $id");
      return;
    }

    // 🔹 Estrai la lista delle locations attuali, se è null inizializzala come []
    List<Map<String, dynamic>> currentLocations =
        List<Map<String, dynamic>>.from(response['locations'] ?? []);

    print("📌 Locations attuali prima dell'update: $currentLocations");

    // 🔹 Aggiungi il nuovo elemento alla lista
    currentLocations.add(item);

    print("🚀 Locations aggiornate da inviare: $currentLocations");

    // 🔹 Aggiorna su Supabase
    final updateResponse = await Supabase.instance.client
        .from('itineraries')
        .update({'locations': currentLocations})
        .eq('id', id)
        .select('locations'); // Ottieni solo locations aggiornato

    if (updateResponse.isEmpty) {
      print("❌ Errore: Nessuna risposta da Supabase dopo l'update.");
      return;
    }

    final updatedLocations = List<Map<String, dynamic>>.from(updateResponse.first['locations']);
    print("✅ Locations aggiornate da Supabase: $updatedLocations");

    // 🔹 Aggiorna lo stato locale
    state = state.map((it) {
      if (it.id == id) {
        return it.copyWith(locations: updatedLocations);
      }
      return it;
    }).toList();

    print("🎉 Itinerario aggiornato con successo!");
  } catch (e) {
    print('❌ Errore nell’aggiunta dell’elemento: $e');
  }
}




  // Rimuovi un elemento (location) da un itinerario
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

  // Carica un singolo itinerario (con tutti i suoi elementi)
  Future<void> loadItineraryDetails(String id) async {
    try {
      final response = await Supabase.instance.client
          .from('itineraries')
          .select()
          .eq('id', id)
          .single();

      if (response != null) {
        final itinerary = Itinerary.fromJson(response);
        state = state.map((it) => it.id == id ? itinerary : it).toList();
      }
    } catch (e) {
      print('Errore nel caricamento dell’itinerario: $e');
    }
  }
}
