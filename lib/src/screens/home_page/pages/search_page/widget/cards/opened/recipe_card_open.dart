import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RecipeOpenCard extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final int time;
  final int peopleFor;
  final List<dynamic> ingredients;

  const RecipeOpenCard({
    super.key,
    required this.title,
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
                color: isDarkTheme
                    ? colorScheme.onSurface.withOpacity(0.7)
                    : colorScheme.surface,
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
                  color:
                      isDarkTheme ? colorScheme.surface : colorScheme.surface,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 20,
                  ),
                  child: ListView(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        width: 420,
                        child: Text(
                          title,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: isDarkTheme
                                ? colorScheme.onSurface
                                : colorScheme.onSurface,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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
                            "$time min.",
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
                        "Ingredienti:",
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
                        "Procedimento",
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
        ],
      ),
    );
  }
}
