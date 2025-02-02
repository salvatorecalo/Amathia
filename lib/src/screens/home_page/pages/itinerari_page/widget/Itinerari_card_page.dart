import 'package:amathia/provider/itinerary_provider.dart';
import 'package:amathia/src/screens/home_page/pages/itinerari_page/model/itineraries.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/opened/city_card_open.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/opened/monument_card_open.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/opened/nature_card_open.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/cards/opened/recipe_card_open.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ItineraryDetailPage extends ConsumerStatefulWidget {
  final String userId; // ID utente
  final Itinerary itinerary; // Itinerario con le location salvate
  final String type;

  const ItineraryDetailPage({
    super.key,
    required this.userId,
    required this.itinerary,
    required this.type,
  });

  @override
  _ItineraryDetailPageState createState() => _ItineraryDetailPageState();
}

class _ItineraryDetailPageState extends ConsumerState<ItineraryDetailPage> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context); // Localizzazione
    String language =
        Localizations.localeOf(context).languageCode; // Lingua corrente
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.itinerary.title), // Nome dell'itinerario
        ),
        body: widget.itinerary.locations.isEmpty
            ? Center(
                child: Text("no location"), // Messaggio se vuoto
              )
            : ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: widget.itinerary.locations.length,
                itemBuilder: (context, index) {
                  final location = widget.itinerary.locations[index];
                  final type = location['type']; // Tipo di carta (es. Ricette)
                  final title = location['title'] ?? 'Unknown';

                  return GestureDetector(
                    onTap: () {
                      //print("LOCATION: ${location}");
                      switch (type) {
                        case "Ricette":
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RecipeOpenCard(
                                userId: widget.userId,
                                title: title,
                                image: location['image'],
                                description:
                                    location['description'] ?? '',
                                time: location['time'] ?? 'Unknown time',
                                peopleFor: location['peopleFor'] ?? 1,
                                ingredients: location['ingredients'] ?? [],
                              ),
                            ),
                          );
                          break;
                        case "Monumenti":
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MonumentOpenCard(
                                userId: widget.userId,
                                location:
                                    location['location'] ?? 'Unknown Location',
                                image: location['image'],
                                title: title,
                                description:
                                    location['description'] ?? '',
                              ),
                            ),
                          );
                          break;
                        case "Natura":
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NatureOpenCard(
                                userId: widget.userId,
                                location:
                                    location['location'] ?? 'Unknown Location',
                                image: location['image'],
                                title: title,
                                description:
                                    location['description'] ?? '',
                              ),
                            ),
                          );
                          break;
                        case "Borghi":
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CityOpenCard(
                                userId: widget.userId,
                                image: location['image'],
                                title: title,
                                description: location['description'],
                              ),
                            ),
                          );
                          break;
                        default:
                          break;
                      }
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Immagine della carta
                          Container(
                            width: 100,
                            height: 75,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                  location['image'],
                                  maxWidth: 200,
                                  maxHeight: 200,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          // Titolo
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 10),
                              child: Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          // Pulsante per rimuovere
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              // Rimuovi l'elemento dall'itinerario
                              await ref
                                  .read(itineraryNotifierProvider(widget.userId)
                                      .notifier)
                                  .removeItemFromItinerary(
                                    widget.itinerary.id,
                                    location,
                                  );
                              setState(() {
                                widget.itinerary.locations.remove(location);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
