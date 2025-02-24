class Itinerary {
  final String id;
  final String userId;
  final String title;
  final List<Map<String, dynamic>> locations;
  final String type;

  Itinerary({
    required this.id,
    required this.userId,
    required this.title,
    this.locations = const [],
    required this.type,
  });

  // Metodo toString per una rappresentazione utile
  @override
  String toString() {
    return 'Itinerary(id: $id, title: $title, locations: $locations, type: $type)';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'locations': locations,
      'type': type,
    };
  }

  factory Itinerary.fromJson(Map<String, dynamic> json) {
    return Itinerary(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String? ?? '',
      locations: (json['locations'] as List<dynamic>?)
              ?.map((item) => item as Map<String, dynamic>)
              .toList() ??
          [],
      type: json['type'] as String? ?? '',
    );
  }

  Itinerary copyWith({
    String? id,
    String? userId,
    String? title,
    List<Map<String, dynamic>>? locations,
    String? type,
  }) {
    return Itinerary(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      locations: locations ?? this.locations,
      type: type ?? this.type,
    );
  }
}
