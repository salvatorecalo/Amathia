import 'dart:math';

import 'package:amathia/src/screens/home_page/pages/search_page/widget/ranDom_advice_thing.dart';
import 'package:flutter/material.dart';

class RandomAdviceGroup extends StatelessWidget {
  final Map<String, List<Widget>> widgetGenerated;

  const RandomAdviceGroup({super.key, required this.widgetGenerated});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widgetGenerated.entries.map((entry) {
        // Selezioniamo un indice casuale e prendiamo il widget interno
        final randomIndex = Random().nextInt(entry.value.length);
        final Widget randomWidget = (entry.value[randomIndex] as Container).child!;

        return RandomAdviceThing(
          tableName: entry.key,
          randomWidget: randomWidget,
        );
      }).toList(),
    );
  }
}
