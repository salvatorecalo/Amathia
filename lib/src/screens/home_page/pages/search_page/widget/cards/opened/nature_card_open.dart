import 'package:amathia/src/costants/costants.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/save_itinerary_button.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/like_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NatureOpenCard extends StatelessWidget {
  final String title;
  final String location;
  final String description;
  final String image;
  final String userId;

  const NatureOpenCard({
    super.key,
    required this.userId,
    required this.title,
    required this.location,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localizations = AppLocalizations.of(context);
    
    return Material(
      child: SafeArea(
        child: Stack(
          children: [
            Image.network(
              image,
              fit: BoxFit.fitHeight,
              width: double.infinity,
              height: 350,
              alignment: Alignment.center,
            ),
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.surface,
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    size: 28,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: double.infinity,
              child: FractionallySizedBox(
                alignment: Alignment.bottomCenter,
                heightFactor: 0.7,
                widthFactor: 1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    color: colorScheme.surface,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 20,
                    ),
                    child: ListView(
                      children: [
                        Row(
                          children: [
                            // Responsive Text width
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: Text(
                                  title,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    color: colorScheme.onSurface,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            LikeButton(
                              userId: userId,
                              itemId: title, // Unique identifier for the item
                              itemData: {
                                'title': title,
                                'image': image,
                                'location': location,
                                'description': description,
                                'type': 'Natura'
                              },
                            ),
                            const SizedBox(width: 10),
                            SaveItineraryButton(
                              type: 'Natura',
                              itineraryId: '',
                              userId: userId,
                              itemData: {
                                'title': title,
                                'image': image,
                                'description': description,
                                'type': 'Natura',
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Icon(
                              Icons.location_pin,
                              color: colorScheme.onSurface,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                location,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: colorScheme.onSurface,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        Text(
                          localizations!.description,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          description,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurface,
                            height: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40),
                    foregroundColor: white, // Colore del testo del bottone
                    backgroundColor: blue, // Colore del bottone
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onPressed: () async {
                    final Uri url =
                        Uri.parse('geo:0,0?q=${Uri.encodeComponent(title)}');
                    if (!await launchUrl(url)) {
                      throw Exception('Could not launch $url');
                    }
                  },
                  child: Text(localizations.getLocation),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
