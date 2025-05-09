import 'package:amathia/provider/itinerary_provider.dart';
import 'package:amathia/src/logic/user_logic/user_provider.dart';
import 'package:amathia/src/screens/home_page/pages/itinerari_page/model/itineraries.dart';
import 'package:amathia/src/screens/home_page/pages/itinerari_page/widget/Itinerari_card_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class ItinerariesPage extends ConsumerStatefulWidget {
  ItinerariesPage({super.key});

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

    Future.microtask(() {
      final userId = ref.read(userIdProvider);
      if (userId != null) {
        ref.read(itineraryNotifierProvider(userId).notifier).loadItineraries();
      }
    });
  }

  void filterItineraries() {
    final query = searchController.text.toLowerCase();
    final userId = ref.watch(userIdProvider);
    if (userId == null) return;

    final itineraries = ref.watch(itineraryNotifierProvider(userId));
    setState(() {
      filteredItineraries = itineraries
          .where((itinerary) => itinerary.title.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userId = ref.watch(userIdProvider);
    if (userId == null) {
      return Center(child: CircularProgressIndicator());
    }

    final itineraries = ref.watch(itineraryNotifierProvider(userId));
    final localizations = AppLocalizations.of(context);

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
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/noItinerary.webp',
                      width: 300,
                    ),
                    Text(
                      localizations!.favoriteEmpty,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
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
                          onPressed: () =>
                              deleteItinerary(itinerary.id, ref),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ItineraryDetailPage(
                                  userId: userId,
                                  itinerary: itinerary,
                                  type: itinerary.type)));
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
    final userId = ref.read(userIdProvider);
    if (userId == null) return;

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
                  userId: userId,
                  title: titleController.text,
                  locations: [],
                  type: 'Trip',
                );

                await ref
                    .read(itineraryNotifierProvider(userId).notifier)
                    .addItinerary(newItinerary);

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

  void editItinerary(Itinerary itinerary, WidgetRef ref) {
    final userId = ref.read(userIdProvider);
    if (userId == null) return;

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
                final updatedItinerary =
                itinerary.copyWith(title: titleController.text);

                await ref
                    .read(itineraryNotifierProvider(userId).notifier)
                    .renameItinerary(itinerary.id, updatedItinerary.title);

                Navigator.pop(context);
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

  void deleteItinerary(String itineraryId, WidgetRef ref) {
    final userId = ref.read(userIdProvider);
    if (userId == null) return;

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
                await ref
                    .read(itineraryNotifierProvider(userId).notifier)
                    .removeItinerary(itineraryId);

                Navigator.pop(context);
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
