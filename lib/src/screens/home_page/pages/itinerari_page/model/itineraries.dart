class Itinerary {
  final String id;
  final String userId;
  final String title;
  final List<dynamic> locations;
  final String type; // Added type field

  Itinerary({
    required this.id,
    required this.userId,
    required this.title,
    this.locations = const [],
    required this.type, // Added type to the constructor
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'locations': locations,
      'type': type, // Include type in the toJson method
    };
  }

  factory Itinerary.fromJson(Map<String, dynamic> json) {
    return Itinerary(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      locations: json['locations'] as List<dynamic>? ?? [],
      type: json['type'] as String, // Parse type from JSON
    );
  }

  // Metodo copyWith
  Itinerary copyWith({
    String? id,
    String? userId,
    String? title,
    List<dynamic>? locations,
    String? type, // Allow changing the type via copyWith
  }) {
    return Itinerary(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      locations: locations ?? this.locations,
      type: type ?? this.type, // Copy the type if provided
    );
  }
}
