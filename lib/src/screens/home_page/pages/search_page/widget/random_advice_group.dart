import 'dart:math';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/ranDom_advice_thing.dart';
import 'package:flutter/material.dart';

class RandomAdviceGroup extends StatelessWidget {
  final Map<String, List<Widget>> widgetGenerated;
  final String userId;
  const RandomAdviceGroup({super.key, required this.widgetGenerated, required this.userId,});

  Widget extractWidget(MapEntry<String, List<Widget>> entry) {
    // Check if the list is empty before generating a random index
    if (entry.value.isEmpty) {
      // Handle the empty list case, for example, return a default widget or an error widget
      return const Text(
          "No advice available"); // Or you could return any default widget
    }

    final randomIndex = Random().nextInt(entry.value.length);
    if (entry.value[randomIndex] is Container &&
        (entry.value[randomIndex] as Container).child != null) {
      return (entry.value[randomIndex] as Container).child!;
    }
    return entry.value[randomIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widgetGenerated.entries.map((entry) {
        return RandomAdviceThing(
          userId: userId,
          tableName: entry.key,
          randomWidget: extractWidget(entry),
        );
      }).toList(),
    );
  }
}
