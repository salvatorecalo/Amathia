class Favorite {
  final String title;
  final String type;
  final String image;
  final String description;
  final String? location;
  final int? peopleFor;
  final String? time;
  final List<String>? ingredients;

  Favorite({
    required this.title,
    required this.type,
    required this.image,
    required this.description,
    this.location,
    this.peopleFor,
    this.time,
    this.ingredients,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      title: json['title'],
      type: json['type'],
      image: json['image'],
      description: json['description'],
      location: json['location'],
      peopleFor: json['peopleFor'],
      time: json['time'],
      ingredients: json['ingredients'] != null
          ? List<String>.from(json['ingredients'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'type': type,
      'image': image,
      'description': description,
      'location': location,
      'peopleFor': peopleFor,
      'time': time,
      'ingredients': ingredients,
    };
  }
}
