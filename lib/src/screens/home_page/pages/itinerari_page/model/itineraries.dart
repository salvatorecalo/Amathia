class Itinerary {
  final String id;
  final String user_id;
  final String title;
  final List<Map<String, dynamic>>? locations;

  Itinerary({
    required this.id,
    required this.user_id,
    required this.title,
    required this.locations,
  });

Itinerary copyWith({
  String? id,
  String? userId,
  String? title,
  List<Map<String, dynamic>>? locations,
}) {
  return Itinerary(
    id: id ?? this.id,
    user_id: userId ?? this.user_id,
    title: title ?? this.title,
    locations: locations ?? this.locations,
  );
}

  factory Itinerary.fromJson(Map<String, dynamic> json) {
  return Itinerary(
    id: json['id'] as String,
    user_id: json['user_id'] as String,
    title: json['title'] as String,
    locations: (json['locations'] as List<dynamic>?)
        ?.map((e) => Map<String, dynamic>.from(e as Map))
        .toList(),
  );
}


  // Metodo toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      "user_id": user_id,
      'title': title,
      'locations': locations,
    };
  }
}
