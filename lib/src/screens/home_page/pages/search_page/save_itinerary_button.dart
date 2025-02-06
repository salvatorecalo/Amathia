import 'package:amathia/src/costants/costants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:amathia/provider/itinerary_provider.dart';
import 'package:amathia/src/screens/home_page/pages/itinerari_page/model/itineraries.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SaveItineraryButton extends ConsumerWidget {
  final String itineraryId;
  final Map<String, dynamic> itemData;
  final String type;

  SaveItineraryButton({
    required this.itineraryId,
    required this.itemData,
    required this.type,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itineraries =
        ref.watch(itineraryNotifierProvider(itemData['userId']));
    final isItemInItinerary = _isItemInItinerary(itineraryId, itineraries);
    final localizations = AppLocalizations.of(context);
    return IconButton(
      icon: Icon(
        isItemInItinerary ? Icons.delete : Icons.bookmark,
        color: isItemInItinerary ? Colors.red : Colors.green,
      ),
      onPressed: () async {
        if (isItemInItinerary) {
          await ref
              .read(itineraryNotifierProvider(itemData['userId']).notifier)
              .removeItemFromItinerary(itineraryId, itemData);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(localizations!.removeFromItinerary)),
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
          id: '',
          userId: itemData['userId'],
          title: '',
          locations: [],
          type: type),
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
              .read(itineraryNotifierProvider(itemData['userId']).notifier)
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
        final localization = AppLocalizations.of(context);
        return AlertDialog(
          title: Text(localization!.selectItinerary),
          content: itineraries.isEmpty
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(localization.noItineraryFound),
                    ElevatedButton(
                      onPressed: () => createItinerary(context, ref),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: blue, // Sfondo blu
                      ),
                      child: Text(localization.createitinerary),
                    ),
                  ],
                )
              : SizedBox(
                  height: 300,
                  width: 300,
                  child: Column(
                    children: [
                      // Pulsante per creare un nuovo itinerario
                      ElevatedButton(
                        onPressed: () => createItinerary(
                            context, ref), // Funzione per creare un itinerario
                        child: Text('Create New Itinerary'),
                      ),
                      // Spazio tra il bottone e la lista
                      SizedBox(height: 16),
                      // Lista degli itinerari
                      Expanded(
                        child: ListView.builder(
                          itemCount: itineraries.length,
                          itemBuilder: (context, index) {
                            final itinerary = itineraries[index];
                            return ListTile(
                              title: Text(itinerary.title),
                              onTap: () async {
                                print("ItemData itinerari: ${itemData}");
                                await ref
                                    .read(itineraryNotifierProvider(
                                            itemData['userId'])
                                        .notifier)
                                    .addItemToItinerary(itinerary.id, itemData);
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      localization
                                          .addedToItinerary(itinerary.title),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
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
                  child: Text(localization.cancel),
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
  final localization = AppLocalizations.of(context);
  final theme = Theme.of(context);
  final primaryColor = theme.colorScheme.primary;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(localization!.createitinerary),
        content: TextField(
          controller: titleController,
          decoration: InputDecoration(hintText: localization!.insertTitle),
        ),
        actions: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final newItinerary = Itinerary(
                    id: uuid.v4(),
                    userId: itemData['userId'] ?? '',
                    title: titleController.text,
                    locations: [
                      itemData
                    ], // Aggiungi l'elemento all'itinerario direttamente
                    type: type,
                  );

                  print('Userid: ${itemData['userId']}');

                  // 🔹 Aggiungi l'itinerario al provider
                  await ref
                      .read(itineraryNotifierProvider(itemData['userId'])
                          .notifier)
                      .addItinerary(newItinerary);

                  Navigator.pop(context);

                  // 🔹 Aggiorna la lista degli itinerari
                  ref.refresh(itineraryNotifierProvider(itemData['userId']));

                  // 🔹 Mostra la lista aggiornata
                  _showItinerarySelectionDialog(
                    context,
                    ref,
                    ref.read(itineraryNotifierProvider(itemData['userId'])),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: blue, // Sfondo blu
                ),
                child: Text(localization.create),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: primaryColor, // Testo blu
                ),
                child: Text(localization.cancel),
              ),
            ],
          ),
        ],
      );
    },
  );
}

}
