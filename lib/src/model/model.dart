import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Data {
  String description;
  String title;
  String location;

  Data({
    required this.title,
    required this.description,
    required this.location,
  });

  factory Data.fromJson(Map<dynamic, dynamic> json) {
    return Data(
      title: json['name'],
      description: json['description'],
      location: json['city'],
    );
  }
}

Future<List<Data>> fetchData() async {
  final response = await http.get(
    Uri.http('http://fake-hotel-api.herokuapp.com/api/hotels'),
  );
  if (response.statusCode == 200) {
    final List jsonResponse = json.decode(response.body) as List;
    return jsonResponse.map((data) => Data.fromJson(data)).toList();
  } else {
    throw Exception(response.body);
  }
}
