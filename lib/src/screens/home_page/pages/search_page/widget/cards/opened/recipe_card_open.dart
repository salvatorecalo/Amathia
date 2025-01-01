import 'package:amathia/src/screens/home_page/pages/search_page/save_itinerary_button.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/like_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class RecipeOpenCard extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final String time;
  final int peopleFor;
  final String userId;
  final List<dynamic> ingredients;

  const RecipeOpenCard({
    super.key,
    required this.title,
    required this.userId,
    required this.description,
    required this.image,
    required this.peopleFor,
    required this.time,
    required this.ingredients,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDarkTheme = theme.brightness == Brightness.dark;
    final localizations = AppLocalizations.of(context);

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
                    color: isDarkTheme ? colorScheme.surface : colorScheme.surface,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 20,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  title,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    color: isDarkTheme
                                        ? colorScheme.onSurface
                                        : colorScheme.onSurface,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                              LikeButton(
                                userId: userId,
                                itemId: title,
                                itemData: {
                                  'title': title,
                                  'image': image,
                                  'type': 'Ricette',
                                  'peoplefor': peopleFor,
                                  'time': time.toString(),
                                  'ingredients': ingredients,
                                  'description': description,
                                },
                              ),
                              const SizedBox(width: 10,),
                              SaveItineraryButton(
                                type: 'Ricette',
                                itineraryId: '',
                                userId: userId,
                                itemData: {
                                  'title': title,
                                  'image': image,
                                  'description': description,
                                  'type': 'Ricette',
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Icon(
                                Icons.schedule,
                                color: isDarkTheme
                                    ? colorScheme.onSurface
                                    : colorScheme.onSurface,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                time,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: isDarkTheme
                                      ? colorScheme.onSurface
                                      : colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.person,
                                color: isDarkTheme
                                    ? colorScheme.onSurface
                                    : colorScheme.onSurface,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '$peopleFor',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: isDarkTheme
                                      ? colorScheme.onSurface
                                      : colorScheme.onSurface,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                          Text(
                            localizations!.ingredients,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: isDarkTheme
                                  ? colorScheme.onSurface
                                  : colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ...ingredients.map(
                            (ingredient) => Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              child: Text(
                                '- $ingredient',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: isDarkTheme
                                      ? colorScheme.onSurface
                                      : colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            localizations.process,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: isDarkTheme
                                  ? colorScheme.onSurface
                                  : colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            description,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: isDarkTheme
                                  ? colorScheme.onSurface
                                  : colorScheme.onSurface,
                              height: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
