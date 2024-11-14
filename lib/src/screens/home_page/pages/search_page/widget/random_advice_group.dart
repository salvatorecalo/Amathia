import 'dart:math';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/ranDom_advice_thing.dart';
import 'package:flutter/material.dart';

class RandomAdviceGroup extends StatelessWidget {
  final Map<String, List<Widget>> widgetGenerated;

  const RandomAdviceGroup({super.key, required this.widgetGenerated});

  Widget extractWidget(MapEntry<String, List<Widget>> entry) {
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
          tableName: entry.key,
          randomWidget: extractWidget(entry),
        );
      }).toList(),
    );
  }
}
