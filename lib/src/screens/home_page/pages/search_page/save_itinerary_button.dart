import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:amathia/provider/itinerary_provider.dart';
import 'package:amathia/src/screens/home_page/pages/itinerari_page/model/itineraries.dart';

class SaveItineraryButton extends ConsumerWidget {
  final String userId;
  final String itineraryId; // id itinerario corrente, non nullo
  final Map<String, dynamic> itemData; // Dati della card da aggiungere/rimuovere
  final String type;

  SaveItineraryButton({
    required this.userId,
    required this.itineraryId,
    required this.itemData,
    required this.type,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Recupera gli itinerari per il specifico userId
    final itineraries = ref.watch(itineraryNotifierProvider(userId));

    // Verifica se l'elemento è già presente nell'itinerario corrente
    final isItemInItinerary = _isItemInItinerary(itineraryId, itineraries);

    return IconButton(
      icon: Icon(
        isItemInItinerary ? Icons.delete : Icons.bookmark, // Icona in base alla presenza dell'elemento
        color: isItemInItinerary ? Colors.red : Colors.green,
      ),
      onPressed: () async {
        if (isItemInItinerary) {
          // Rimuove l'elemento dall'itinerario corrente
          await ref.read(itineraryNotifierProvider(userId).notifier).removeItemFromItinerary(itineraryId, itemData);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Rimosso dall'itinerario")),
          );
        } else {
          // Prima di aggiungere l'elemento, rimuovilo da qualsiasi altro itinerario
          await _removeItemFromOtherItineraries(ref, itineraries);

          // Mostra il dialogo per selezionare un itinerario e aggiungere l'elemento
          _showItinerarySelectionDialog(context, ref, itineraries);
        }
      },
    );
  }

  // Verifica se l'elemento è presente nell'itinerario
  bool _isItemInItinerary(String itineraryId, List<Itinerary> itineraries) {
    final itinerary = itineraries.firstWhere(
      (itinerary) => itinerary.id == itineraryId,
      orElse: () => Itinerary(id: '', userId: userId, title: '', locations: [], type: type),
    );
    return itinerary.locations.any((location) => location['id'] == itemData['id']);
  }

  // Rimuove l'elemento da tutti gli itinerari in cui è presente
  Future<void> _removeItemFromOtherItineraries(WidgetRef ref, List<Itinerary> itineraries) async {
    for (var itinerary in itineraries) {
      if (itinerary.id != itineraryId) {
        final isItemInItinerary = itinerary.locations.any((location) => location['id'] == itemData['id']);
        if (isItemInItinerary) {
          await ref.read(itineraryNotifierProvider(userId).notifier).removeItemFromItinerary(itinerary.id, itemData);
        }
      }
    }
  }

  // Mostra il dialogo per selezionare un itinerario
  void _showItinerarySelectionDialog(
    BuildContext context, WidgetRef ref, List<Itinerary> itineraries) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Seleziona un Itinerario"),
          content: itineraries.isEmpty
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Nessun itinerario trovato."),
                    ElevatedButton(
                      onPressed: () => createItinerary(context, ref),
                      child: const Text("Crea un itinerario"),
                    ),
                  ],
                )
              : SizedBox(
                  height: 300,
                  width: 300,
                  child: ListView.builder(
                    itemCount: itineraries.length,
                    itemBuilder: (context, index) {
                      final itinerary = itineraries[index];
                      return ListTile(
                        title: Text(itinerary.title),
                        onTap: () async {
                          // Aggiungi l'elemento all'itinerario selezionato
                          await ref
                              .read(itineraryNotifierProvider(userId).notifier)
                              .addItemToItinerary(itinerary.id, itemData);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Aggiunto a ${itinerary.title}")),
                          );
                        },
                      );
                    },
                  ),
                ),
        );
      },
    );
  }

  // Crea un nuovo itinerario
  void createItinerary(BuildContext context, WidgetRef ref) {
    final TextEditingController titleController = TextEditingController();
    final uuid = Uuid();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Crea Itinerario'),
          content: TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: 'Inserisci il titolo'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                final newItinerary = Itinerary(
                  type: type,
                  id: uuid.v4(),
                  userId: userId, // Può essere dinamico
                  title: titleController.text,
                  locations: [],
                );

                // Aggiunge il nuovo itinerario
                ref
                    .read(itineraryNotifierProvider(userId).notifier)
                    .addItinerary(newItinerary);

                // Chiudi il dialogo di creazione
                Navigator.pop(context);

                // Riapri il dialogo per selezionare un itinerario, includendo il nuovo
                _showItinerarySelectionDialog(context, ref, ref.read(itineraryNotifierProvider(userId)));
              },
              child: const Text('Crea'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annulla'),
            ),
          ],
        );
      },
    );
  }
}
