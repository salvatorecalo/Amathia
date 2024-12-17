import 'package:amathia/provider/itinerary_provider.dart';
import 'package:amathia/src/screens/home_page/pages/itinerari_page/model/itineraries.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SaveItineraryButton extends ConsumerWidget {
  final String userId;
  final String itineraryId; // id itinerario corrente, non nullo
  final Map<String, dynamic> itemData; // Dati della card da aggiungere/rimuovere

  SaveItineraryButton({
    required this.userId,
    required this.itineraryId,
    required this.itemData,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itineraries = ref.watch(itineraryNotifierProvider);

    // Verifica se l'elemento è già presente nell'itinerario
    final isItemInItinerary = _isItemInItinerary(itineraryId, itineraries);

    return IconButton(
      icon: Icon(
        isItemInItinerary ? Icons.delete : Icons.add, // Icona in base alla presenza dell'elemento
        color: isItemInItinerary ? Colors.red : Colors.green,
      ),
      onPressed: () async {
        if (isItemInItinerary) {
          // Rimuove l'elemento dall'itinerario
          await ref.read(itineraryNotifierProvider.notifier).removeItemFromItinerary(itineraryId, itemData);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Rimosso dall'itinerario")),
          );
        } else {
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
      orElse: () => Itinerary(id: '', userId: userId, title: '', locations: []),
    );
    return itinerary.locations.any((location) => location['id'] == itemData['id']);
  }

  void _showItinerarySelectionDialog(BuildContext context, WidgetRef ref, List<Itinerary> itineraries) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Seleziona un Itinerario"),
          content: SizedBox(
            height: 300,
            width: 300,
            child: ListView.builder(
              itemCount: itineraries.length,
              itemBuilder: (context, index) {
                final itinerary = itineraries[index];
                return ListTile(
                  title: Text(itinerary.title),
                  onTap: () async {
                    await ref.read(itineraryNotifierProvider.notifier).addItemToItinerary(itinerary.id, itemData);
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
}
