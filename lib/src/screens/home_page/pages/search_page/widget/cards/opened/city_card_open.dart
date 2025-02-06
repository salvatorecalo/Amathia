import 'package:amathia/src/costants/costants.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/like_button.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/save_itinerary_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CityOpenCard extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final String userId;
  final String itineraryId;

  const CityOpenCard({
    super.key,
    required this.userId,
    required this.itineraryId,
    required this.title,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkTheme = theme.brightness == Brightness.dark;

    return Material(
      child: SafeArea(
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: image,
              width: double.infinity,
              height: 350,
              fit: BoxFit.cover,
              alignment: Alignment.center,
              errorWidget: (context, error, stackTrace) {
                return const Icon(
                    Icons.error); // Mostra un'icona in caso di errore
              },
              placeholder: (context, url) {
                return Center(child: const CircularProgressIndicator());
              },
            ),
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDarkTheme ? Colors.black54 : Colors.white,
                ),
                child: IconButton(
                  hoverColor: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    size: 28,
                    color: isDarkTheme ? Colors.white : Colors.black,
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
                    child: SingleChildScrollView(
                      // Aggiungi lo scroll
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  title,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 24,
                                    overflow: TextOverflow
                                        .ellipsis, // Previeni l'overflow
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                              Row(
                                children: [
                                  LikeButton(
                                    itemId: title,
                                    itemData: {
                                      'userId': userId,
                                      'title': title,
                                      'image': image,
                                      'type': 'Borghi',
                                      'description': description,
                                    },
                                  ),
                                  const SizedBox(width: 10),
                                  SaveItineraryButton(
                                    type: 'Borghi',
                                    itineraryId: itineraryId,
                                    itemData: {
                                      'userId': userId,
                                      'title': title,
                                      'image': image,
                                      'description': description,
                                      'type': 'Borghi',
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Text(
                            localizations!.story,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 30.0),
                            child: Text(
                              description,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                height: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
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
                    foregroundColor: white,
                    backgroundColor: blue,
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
