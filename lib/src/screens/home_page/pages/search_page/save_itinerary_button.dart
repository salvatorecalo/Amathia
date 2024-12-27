import 'package:amathia/src/costants/costants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:amathia/provider/itinerary_provider.dart';
import 'package:amathia/src/screens/home_page/pages/itinerari_page/model/itineraries.dart';

class SaveItineraryButton extends ConsumerWidget {
  final String userId;
  final String itineraryId;
  final Map<String, dynamic> itemData;
  final String type;

  SaveItineraryButton({
    required this.userId,
    required this.itineraryId,
    required this.itemData,
    required this.type,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itineraries = ref.watch(itineraryNotifierProvider(userId));
    final isItemInItinerary = _isItemInItinerary(itineraryId, itineraries);

    return IconButton(
      icon: Icon(
        isItemInItinerary ? Icons.delete : Icons.bookmark,
        color: isItemInItinerary ? Colors.red : Colors.green,
      ),
      onPressed: () async {
        if (isItemInItinerary) {
          await ref
              .read(itineraryNotifierProvider(userId).notifier)
              .removeItemFromItinerary(itineraryId, itemData);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Rimosso dall'itinerario")),
          );
        } else {
          await _removeItemFromOtherItineraries(ref, itineraries);
          _showItinerarySelectionDialog(context, ref, itineraries);
        }
      },
    );
  }

  bool _isItemInItinerary(String itineraryId, List<Itinerary> itineraries) {
    final itinerary = itineraries.firstWhere(
      (itinerary) => itinerary.id == itineraryId,
      orElse: () => Itinerary(
          id: '', userId: userId, title: '', locations: [], type: type),
    );
    return itinerary.locations
        .any((location) => location['id'] == itemData['id']);
  }

  Future<void> _removeItemFromOtherItineraries(
      WidgetRef ref, List<Itinerary> itineraries) async {
    for (var itinerary in itineraries) {
      if (itinerary.id != itineraryId) {
        final isItemInItinerary = itinerary.locations
            .any((location) => location['id'] == itemData['id']);
        if (isItemInItinerary) {
          await ref
              .read(itineraryNotifierProvider(userId).notifier)
              .removeItemFromItinerary(itinerary.id, itemData);
        }
      }
    }
  }

  void _showItinerarySelectionDialog(
      BuildContext context, WidgetRef ref, List<Itinerary> itineraries) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

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
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: blue, // Sfondo blu
                      ),
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
                          await ref
                              .read(itineraryNotifierProvider(userId).notifier)
                              .addItemToItinerary(itinerary.id, itemData);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text("Aggiunto a ${itinerary.title}")),
                          );
                        },
                      );
                    },
                  ),
                ),
          actions: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: primaryColor, // Testo blu
                  ),
                  child: const Text('Annulla'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void createItinerary(BuildContext context, WidgetRef ref) {
    final TextEditingController titleController = TextEditingController();
    final uuid = Uuid();

    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

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
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () {
                    final newItinerary = Itinerary(
                      type: type,
                      id: uuid.v4(),
                      userId: userId,
                      title: titleController.text,
                      locations: [],
                    );

                    ref
                        .read(itineraryNotifierProvider(userId).notifier)
                        .addItinerary(newItinerary);

                    Navigator.pop(context);
                    _showItinerarySelectionDialog(context, ref,
                        ref.read(itineraryNotifierProvider(userId)));
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: blue, // Sfondo blu
                  ),
                  child: const Text('Crea'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    foregroundColor: primaryColor, // Testo blu
                  ),
                  child: const Text('Annulla'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
