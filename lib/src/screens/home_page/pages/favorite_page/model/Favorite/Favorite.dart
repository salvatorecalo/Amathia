class Favorite {
  final String title;
  final String type;
  final String image;
  final String description;
  final String? location;
  final int? peoplefor;
  final String? time;
  final List<String>? ingredients;
  final String userId;
  Favorite({
    required this.title,
    required this.type,
    required this.image,
    required this.description,
    required this.userId,
    this.location,
    this.peoplefor,
    this.time,
    this.ingredients,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      title: json['title'],
      userId: json['userId'],
      type: json['type'],
      image: json['image'],
      description: json['description'],
      location: json['location'],
      peoplefor: json['peoplefor'],
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
      'peoplefor': peoplefor,
      'time': time,
      'ingredients': ingredients,
      'userId': userId,
    };
  }
}
