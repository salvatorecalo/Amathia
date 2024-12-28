import 'package:amathia/provider/itinerary_provider.dart';
import 'package:amathia/src/costants/costants.dart';
import 'package:amathia/src/screens/home_page/pages/itinerari_page/model/itineraries.dart';
import 'package:amathia/src/screens/home_page/pages/itinerari_page/widget/Itinerari_card_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

// ignore: must_be_immutable
class ItinerariesPage extends ConsumerStatefulWidget {
  String userId;
  ItinerariesPage({super.key, required this.userId});

  @override
  _ItinerariesPageState createState() => _ItinerariesPageState();
}

class _ItinerariesPageState extends ConsumerState<ItinerariesPage> {
  final TextEditingController searchController = TextEditingController();
  List<Itinerary> filteredItineraries = [];
  String selectedType = "Ricette"; // Tipo predefinito

  @override
  void initState() {
    super.initState();
    searchController.addListener(() => filterItineraries());
  }

  void filterItineraries() {
    final query = searchController.text.toLowerCase();
    final itineraries = ref.watch(itineraryNotifierProvider(widget.userId));
    setState(() {
      filteredItineraries = itineraries
          .where((it) => it.title.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final itineraries = ref.watch(itineraryNotifierProvider(widget.userId));

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                localizations.itineraries,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: localizations.searchItineraries,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => createItinerary(context, ref),
              child: Text(localizations.createitinerary),
            ),
            Expanded(
              child: itineraries.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/no_favorite.png',
                            width: 200,
                          ),
                          Text(localizations.itinineraryEmpty),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: itineraries.length,
                      itemBuilder: (context, index) {
                        final itinerary = itineraries[index];
                        return TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ItineraryDetailPage(
                                  itinerary: itinerary,
                                  type: itinerary.type,
                                  userId: widget.userId,
                                ),
                              ),
                            );
                          },
                          child: ListTile(
                            title: Text(itinerary.title),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () =>
                                      editItinerary(itinerary, ref),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => ref
                                      .read(itineraryNotifierProvider(
                                              widget.userId)
                                          .notifier)
                                      .deleteItinerary(itinerary.id),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void createItinerary(BuildContext context, WidgetRef ref) {
    final TextEditingController titleController = TextEditingController();
    final uuid = Uuid();

    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final textColor = theme.colorScheme.onSurface; // Colore testo dinamico
        final localizations = AppLocalizations.of(context);
        return AlertDialog(
          title: Text(localizations!.createitinerary),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration:
                    InputDecoration(hintText: localizations.insertTitle),
              ),
            ],
          ),
          actions: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: white,
                    backgroundColor: blue,
                    minimumSize: const Size(
                        double.infinity, 50), // Aggiungi una larghezza di 100%
                  ),
                  onPressed: () {
                    final newItinerary = Itinerary(
                      id: uuid.v4(),
                      userId: widget.userId, // Può essere dinamico
                      title: titleController.text,
                      locations: [],
                      type: selectedType, // Aggiungi il tipo qui
                    );
                    ref
                        .read(itineraryNotifierProvider(widget.userId).notifier)
                        .addItinerary(newItinerary);
                    Navigator.pop(context);
                  },
                  child: Text(
                    localizations.create,
                    style: TextStyle(
                      color: white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor:
                        textColor, // Imposta il colore dinamico del testo
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    localizations.cancel,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void editItinerary(Itinerary itinerary, WidgetRef ref) {
    final TextEditingController titleController =
        TextEditingController(text: itinerary.title);

    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final textColor = theme.colorScheme.onSurface; // Colore testo dinamico
        final localization = AppLocalizations.of(context);
        return AlertDialog(
          title: Text(localization!.editTitle),
          content: TextField(
            controller: titleController,
            decoration: InputDecoration(hintText: localization.editTitle),
          ),
          actions: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: white,
                    backgroundColor: blue,
                    minimumSize: const Size(
                        double.infinity, 50), // Aggiungi una larghezza di 100%
                  ),
                  onPressed: () {
                    final updatedItinerary =
                        itinerary.copyWith(title: titleController.text);
                    ref
                        .read(itineraryNotifierProvider(widget.userId).notifier)
                        .updateItinerary(updatedItinerary);
                    Navigator.pop(context);
                  },
                  child: Text(
                    localization.save,
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor:
                        textColor, // Imposta il colore dinamico del testo
                  ),
                  onPressed: () => Navigator.pop(context),
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
