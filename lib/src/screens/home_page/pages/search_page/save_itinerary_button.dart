import 'package:amathia/provider/itinerary_provider.dart';
import 'package:amathia/src/screens/home_page/pages/itinerari_page/model/itineraries.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SaveItineraryButton extends ConsumerWidget {
  final String itineraryId;
  final String userId;

  const SaveItineraryButton({
    super.key,
    required this.itineraryId,
    required this.userId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Ottenere il provider e il notifier per gestire lo stato
    final itineraryNotifier = ref.read(itineraryProvider(userId).notifier);
    final itineraries = ref.watch(itineraryProvider(userId));

    // Controlla se l'itinerario è già salvato
    final isSaved = itineraries.any((itinerary) => itinerary.id == itineraryId);

    return IconButton(
      icon: Icon(
        isSaved ? Icons.bookmark : Icons.bookmark_add,
        color: isSaved ? Colors.blue : Colors.grey,
      ),
      tooltip: isSaved
          ? 'Rimuovi dai preferiti' // Cambia tooltip dinamicamente
          : 'Aggiungi ai preferiti',
      onPressed: () async {
        try {
          if (isSaved) {
            // Rimuovi l'itinerario dai preferiti
            await itineraryNotifier.deleteItinerary(itineraryId);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Itinerario rimosso dai preferiti'),
                duration: const Duration(seconds: 2),
              ),
            );
          } else {
            // Aggiungi l'itinerario ai preferiti
            await itineraryNotifier.addItinerary(
              Itinerary(
                id: itineraryId,
                userId: userId,
                title: 'Nuovo Itinerario', // Cambiare con un titolo dinamico
                locations: [],
              ),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Itinerario aggiunto ai preferiti'),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        } catch (error) {
          debugPrint("Errore nella gestione dell'itinerario: $error");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Si è verificato un errore durante l\'operazione. Riprova.'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
    );
  }
}
