import 'package:amathia/src/costants/costants.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/like_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CityOpenCard extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final String userId;

  const CityOpenCard({
    super.key,
    required this.userId,
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
                  color:
                      colorScheme.surface, // Usa il colore di sfondo del tema
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
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            width: 300,
                            child: Text(
                              title,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          LikeButton(
                    itemId: title, 
                    userId: userId,
                    itemData: {
                      'title': title,
                      'image': image,
                      'type': 'Borghi',
                      'description': description,
                    },
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
    );
  }
}
