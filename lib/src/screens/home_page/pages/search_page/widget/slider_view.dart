import 'package:amathia/src/model/model.dart';
import 'package:amathia/src/screens/home_page/pages/search_page/widget/host_Card.dart';
import 'package:flutter/material.dart';

class SliderView extends StatefulWidget {
  final String message;
  const SliderView({
    super.key,
    required this.message,
  });

  @override
  State<SliderView> createState() => _SliderViewState();
}

class _SliderViewState extends State<SliderView> {
  late Future<List<Data>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.message,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          padding: const EdgeInsets.all(5),
          height: 250,
          child: FutureBuilder<List<Data>>(
            future: futureData,
            builder: (context, snapshot) {
              try {
                if (snapshot.hasData) {
                  List<Data> data = snapshot.data!;
                  return Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return HostCard(
                          title: (data[index].title),
                          location: data[index].location,
                          description: data[index].description,
                        );
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
              } catch (e) {
                print(e.toString());
                rethrow;
              }
              return Text("it works");
            },
          ),
        ),
      ],
    );
  }
}
