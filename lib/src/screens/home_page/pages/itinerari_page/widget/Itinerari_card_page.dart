import 'package:amathia/src/costants/costants.dart';
import 'package:amathia/src/screens/home_page/pages/itinerari_page/model/itineraries.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ItineraryDetailPage extends StatefulWidget {
  final Itinerary itinerary;

  const ItineraryDetailPage({Key? key, required this.itinerary})
      : super(key: key);

  @override
  State<ItineraryDetailPage> createState() => _ItineraryDetailPageState();
}

class _ItineraryDetailPageState extends State<ItineraryDetailPage> {
  String selectedSortCriteria = 'title'; // Criterio di ordinamento predefinito

  // Funzione per ordinare la lista di località in base al criterio selezionato
  List<Map<String, dynamic>> _sortLocations(List<Map<String, dynamic>> locations) {
    switch (selectedSortCriteria) {
      case 'title':
        locations.sort((a, b) => a['title'].compareTo(b['title']));
        break;
      case 'type':
        locations.sort((a, b) => a['type'].compareTo(b['type']));
        break;
      case 'location':
        locations.sort((a, b) => a['location'].compareTo(b['location']));
        break;
      default:
        break;
    }
    return locations;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    // Categorie
    final Map<String, List<Map<String, dynamic>>> categorizedLocations = {
      'Ricette': [],
      'Borghi': [],
      'Monumenti': [],
      'Natura': [],
    };

    // Distribuisci le località nelle categorie
    if (widget.itinerary.locations != null) {
      for (var location in widget.itinerary.locations!) {
        final type = location['type'] ?? 'Altro';
        if (categorizedLocations.containsKey(type)) {
          categorizedLocations[type]!.add(location);
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.itinerary.title,
          style: const TextStyle(
            color: white,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dropdown per selezionare il criterio di ordinamento
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  localizations!.sortBy,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: selectedSortCriteria,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedSortCriteria = value;
                      });
                    }
                  },
                  items: [
                    DropdownMenuItem(
                      value: 'title',
                      child: Text(localizations.sortByTitle),
                    ),
                    DropdownMenuItem(
                      value: 'type',
                      child: Text(localizations.sortByType),
                    ),
                    DropdownMenuItem(
                      value: 'location',
                      child: Text(localizations.sortByLocation),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: categorizedLocations.entries.map((entry) {
                final title = entry.key;
                final items = _sortLocations(entry.value);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Titolo della sezione
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        title,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    // Contenuto della sezione o messaggio vuoto
                    items.isNotEmpty
                        ? Column(
                            children: items.map((location) {
                              return ListTile(
                                title: Text(location['title'] ?? localizations.titleNotAvailable),
                                subtitle: Text(location['location'] ?? localizations.descriptionNotAvailable),
                                onTap: () {
                                  // Naviga a una pagina di dettaglio della carta se necessario
                                },
                              );
                            }).toList(),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              localizations.favoriteEmpty, // Messaggio sezione vuota
                              style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                            ),
                          ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
