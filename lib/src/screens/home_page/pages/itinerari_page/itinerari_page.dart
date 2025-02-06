import 'package:amathia/provider/itinerary_provider.dart';
import 'package:amathia/src/screens/home_page/pages/itinerari_page/model/itineraries.dart';
import 'package:amathia/src/screens/home_page/pages/itinerari_page/widget/Itinerari_card_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class ItinerariesPage extends ConsumerStatefulWidget {
  final String userId;
  ItinerariesPage({super.key, required this.userId});

  @override
  _ItinerariesPageState createState() => _ItinerariesPageState();
}

class _ItinerariesPageState extends ConsumerState<ItinerariesPage> {
  final TextEditingController searchController = TextEditingController();
  List<Itinerary> filteredItineraries = [];

  @override
  void initState() {
    super.initState();
    searchController.addListener(() => filterItineraries());

    // Carica gli itinerari solo una volta quando la pagina è caricata per la prima volta
    final itineraries = ref.read(itineraryNotifierProvider(widget.userId));
    
    if (itineraries.isEmpty) {
      ref.read(itineraryNotifierProvider(widget.userId).notifier).loadItineraries();
    }
  }

  void filterItineraries() {
    final query = searchController.text.toLowerCase();
    final itineraries = ref.watch(itineraryNotifierProvider(widget.userId));
    
    setState(() {
      filteredItineraries = itineraries
          .where((itinerary) => itinerary.title.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final itineraries = ref.watch(itineraryNotifierProvider(widget.userId));
    print("Itinerari: $itineraries");
    print("User id: ${widget.userId}");

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Itineraries',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search itineraries',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => createItinerary(context, ref),
              child: Text('Create Itinerary'),
            ),
            Expanded(
              child: itineraries.isEmpty
                  ? Center(child: Text("No itinerarti"),) // Show loading while fetching
                  : ListView.builder(
                      itemCount: filteredItineraries.isNotEmpty
                          ? filteredItineraries.length
                          : itineraries.length,
                      itemBuilder: (context, index) {
                        final itinerary = filteredItineraries.isNotEmpty
                            ? filteredItineraries[index]
                            : itineraries[index];

                        return ListTile(
                          title: Text(itinerary.title),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => editItinerary(itinerary, ref),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => deleteItinerary(itinerary.id, ref),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ItineraryDetailPage(userId: widget.userId, itinerary: itinerary, type: itinerary.type)));
                          },
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
      return AlertDialog(
        title: Text('Create Itinerary'),
        content: TextField(
          controller: titleController,
          decoration: InputDecoration(hintText: 'Enter itinerary title'),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              final newItinerary = Itinerary(
                id: uuid.v4(),
                userId: widget.userId,
                title: titleController.text,
                locations: [],
                type: 'Trip',
              );

              // Aggiungi itinerario
              await ref.watch(itineraryNotifierProvider(widget.userId).notifier)
                  .addItinerary(newItinerary);

              // Aggiorna direttamente la lista locale
              setState(() {
                filteredItineraries.add(newItinerary);
              });

              Navigator.pop(context);
            },
            child: Text('Create'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      );
    },
  );
}


  /// 🔹 Modifica un itinerario esistente
  void editItinerary(Itinerary itinerary, WidgetRef ref) {
    final TextEditingController titleController =
        TextEditingController(text: itinerary.title);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Itinerary'),
          content: TextField(
            controller: titleController,
            decoration: InputDecoration(hintText: 'Edit itinerary title'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                final updatedItinerary = itinerary.copyWith(title: titleController.text);

                await ref.read(itineraryNotifierProvider(widget.userId).notifier)
                    .updateItinerary(updatedItinerary);

                Navigator.pop(context);

                // Non invalidare il provider, aggiorna direttamente lo stato
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  /// 🔹 Elimina un itinerario
  void deleteItinerary(String itineraryId, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Itinerary'),
          content: Text('Are you sure you want to delete this itinerary?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await ref.read(itineraryNotifierProvider(widget.userId).notifier)
                    .deleteItinerary(itineraryId);

                Navigator.pop(context);

                // Non invalidare il provider, aggiorna direttamente lo stato
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
