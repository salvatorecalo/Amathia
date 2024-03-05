import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Data {
  String description;
  String title;
  String location;
  int price;
  double rating;
  List images;

  Data({
    required this.title,
    required this.price,
    required this.description,
    required this.rating,
    required this.location,
    required this.images,
  });

  factory Data.fromJson(Map<dynamic, dynamic> json) {
    return Data(
      title: json['name'],
      description: json['description'],
      price: json['price'],
      rating: json['rating'],
      location: json['city'],
      images: json['images'],
    );
  }
}

Future<List<Data>> fetchData() async {
  final response = await http.get(
    Uri.parse('http://fake-hotel-api.herokuapp.com/api/hotels'),
  );
  if (response.statusCode == 200) {
    final List jsonResponse = json.decode(response.body) as List;
    return jsonResponse.map((data) => new Data.fromJson(data)).toList();
  } else {
    throw Exception(response.body);
  }
}