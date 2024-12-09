import 'package:amathia/provider/itinerary_notifier.dart';
import 'package:amathia/src/screens/home_page/pages/itinerari_page/model/itineraries.dart';
import 'package:amathia/src/screens/home_page/pages/itinerari_page/widget/Itinerari_card_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

class ItinerariesPage extends StatefulWidget {
  final String userId;

  const ItinerariesPage({Key? key, required this.userId}) : super(key: key);

  @override
  _ItinerariesPageState createState() => _ItinerariesPageState();
}

class _ItinerariesPageState extends State<ItinerariesPage> {
  List<Itinerary> itineraries = [];
  List<Itinerary> filteredItineraries = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadItineraries();
  }

  Future<void> loadItineraries() async {
    try {
      final userItineraries =
          (await ItineraryNotifier(widget.userId).loadItineraries())
              .cast<Itinerary>();
      if (mounted) {
        setState(() {
          itineraries = userItineraries;
          filteredItineraries = userItineraries;
        });
      }
    } catch (error) {
      debugPrint("Errore durante il caricamento degli itinerari: $error");
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    if (localizations == null) {
      return const Center(
        child: Text("Errore: Localizzazioni non disponibili."),
      );
    }

    void createItinerary() {
      TextEditingController titleController = TextEditingController();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(localizations.createitinerary),
            content: TextField(
              controller: titleController,
              decoration: InputDecoration(hintText: localizations.insertTitle),
            ),
            actions: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final uuid = Uuid();
                      final newItinerary = Itinerary(
                        id: uuid.v4(),
                        user_id: widget.userId,
                        title: titleController.text,
                        locations: [],
                      );
                      try {
                        await ItineraryNotifier(widget.userId)
                            .addItinerary(newItinerary);
                        if (mounted) {
                          setState(() {
                            itineraries.add(newItinerary);
                            filteredItineraries = itineraries;
                          });
                        }
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text(localizations.successfulCreateItinenary),
                          ),
                        );
                      } catch (error) {
                        debugPrint("Errore durante la creazione: $error");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                    ),
                    child: Text(localizations.create),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(localizations.cancel),
                  ),
                ],
              ),
            ],
          );
        },
      );
    }

    void filterItineraries(String query) {
      final filtered = itineraries.where((itinerary) {
        return itinerary.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
      setState(() {
        filteredItineraries = filtered;
      });
    }

    void deleteItinerary(Itinerary itinerary) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(localizations.confirmDelete),
            content: Text(
                '${localizations.deleteConfirmation} "${itinerary.title}"?'),
            actions: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await ItineraryNotifier(widget.userId)
                            .deleteItinerary(itinerary.id);
                        if (mounted) {
                          setState(() {
                            itineraries
                                .removeWhere((it) => it.id == itinerary.id);
                            filteredItineraries = itineraries;
                          });
                        }
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Itinerario "${itinerary.title}" eliminato con successo!'),
                          ),
                        );
                      } catch (error) {
                        debugPrint("Errore durante l'eliminazione: $error");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                    ),
                    child: Text(localizations.delete),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(localizations.cancel),
                  ),
                ],
              ),
            ],
          );
        },
      );
    }

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: Text(
                localizations.itineraries,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
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
                onChanged: filterItineraries,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                ),
                onPressed: createItinerary,
                child: Text(localizations.createitinerary),
              ),
            ),
            Expanded(
              child: filteredItineraries.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/no_favorite.png',
                            width: 200,
                          ),
                          Text(
                            localizations.itinineraryEmpty,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredItineraries.length,
                      itemBuilder: (context, index) {
                        final itinerary = filteredItineraries[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ItineraryDetailPage(
                                  itinerary: itinerary,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 18),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(itinerary.title),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () =>
                                          deleteItinerary(itinerary),
                                    ),
                                  ],
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
}
