import 'dart:math';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/ranDom_advice_thing.dart';
import 'package:flutter/material.dart';

class RandomAdviceGroup extends StatefulWidget {
  final Map<String, List<Widget>> widgetGenerated;
  final String userId;
  final String itineraryId;

  const RandomAdviceGroup({
    super.key,
    required this.widgetGenerated,
    required this.userId,
    required this.itineraryId,
  });

  @override
  State<RandomAdviceGroup> createState() => _RandomAdviceGroupState();
}

class _RandomAdviceGroupState extends State<RandomAdviceGroup> {
  // Variabile per memorizzare gli indici random selezionati per ciascuna categoria
  late Map<String, int> randomIndices;

  @override
  void initState() {
    super.initState();
    // Inizializza la mappa degli indici casuali
    randomIndices = {};
    widget.widgetGenerated.forEach((key, value) {
      randomIndices[key] = Random().nextInt(
          value.length); // Imposta un indice casuale per ogni categoria
    });
  }

  Widget extractWidget(MapEntry<String, List<Widget>> entry) {
    // Verifica se la lista è vuota prima di generare un indice casuale
    if (entry.value.isEmpty) {
      return const Text(
          "No advice available"); // O puoi restituire un widget di default
    }

    final randomIndex = randomIndices[entry.key] ?? 0;
    return entry.value[randomIndex];
  }

  // Funzione per aggiornare un nuovo widget casuale quando l'utente interagisce
  void updateRandomWidget(String tableName) {
    setState(() {
      // Seleziona un nuovo indice casuale per la categoria
      randomIndices[tableName] =
          Random().nextInt(widget.widgetGenerated[tableName]!.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.widgetGenerated.entries.map((entry) {
        return GestureDetector(
          onTap: () {
            // Quando l'utente preme sul widget, cambia la selezione casuale
            updateRandomWidget(entry.key);
          },
          child: RandomAdviceThing(
            itineraryId: widget.itineraryId,
            userId: widget.userId,
            tableName: entry.key,
            randomWidget: extractWidget(
                entry), // Restituisce il widget casuale selezionato
          ),
        );
      }).toList(),
    );
  }
}
