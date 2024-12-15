class Itinerary {
  final String id;
  final String userId;
  final String title;
  final List<dynamic> locations;

  Itinerary({
    required this.id,
    required this.userId,
    required this.title,
    this.locations = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'locations': locations,
    };
  }

  factory Itinerary.fromJson(Map<String, dynamic> json) {
    return Itinerary(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      locations: json['locations'] as List<dynamic>? ?? [],
    );
  }

  // Metodo copyWith
  Itinerary copyWith({
    String? id,
    String? userId,
    String? title,
    List<dynamic>? locations,
  }) {
    return Itinerary(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      locations: locations ?? this.locations,
    );
  }
}
