import 'package:amathia/src/costants/costants.dart';
import 'package:flutter/material.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Salvati'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 100,
            width: double.infinity,
            child: ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: InputChip(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    backgroundColor: Colors.orangeAccent,
                    avatar: const Icon(
                      Icons.restaurant,
                      color: white,
                    ),
                    label: const Text(
                      'Ricette',
                      style: TextStyle(color: white),
                    ),
                    onSelected: (bool value) {},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: InputChip(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    backgroundColor: Colors.pinkAccent,
                    avatar: const Icon(
                      Icons.account_balance,
                      color: white,
                    ),
                    label: const Text(
                      'Monumenti',
                      style: TextStyle(color: white),
                    ),
                    onSelected: (bool value) {},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: InputChip(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    backgroundColor: Colors.blueAccent,
                    avatar: const Icon(
                      Icons.restaurant,
                      color: white,
                    ),
                    label: const Text(
                      'Natura',
                      style: TextStyle(color: white),
                    ),
                    onSelected: (bool value) {},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: InputChip(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    backgroundColor: Colors.greenAccent,
                    avatar: const Icon(
                      Icons.pedal_bike,
                      color: white,
                    ),
                    label: const Text(
                      'Natura',
                      style: TextStyle(color: white),
                    ),
                    onSelected: (bool value) {},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: InputChip(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    backgroundColor: Colors.blueAccent,
                    avatar: const Icon(
                      Icons.water,
                      color: white,
                    ),
                    label: const Text(
                      'Mare',
                      style: TextStyle(color: white),
                    ),
                    onSelected: (bool value) {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
