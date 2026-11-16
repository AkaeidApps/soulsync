class ProfileModel {
  final String id;
  final String name;
  final int age;
  final String location;
  final String bio;
  final List<String> interests;
  final String imageUrl;
  final double distanceKm;

  const ProfileModel({
    required this.id,
    required this.name,
    required this.age,
    required this.location,
    required this.bio,
    required this.interests,
    required this.imageUrl,
    required this.distanceKm,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'New friend',
      age: (json['age'] as num?)?.toInt() ?? 24,
      location: json['location'] as String? ?? 'Dhaka',
      bio: json['bio'] as String? ?? '',
      interests: (json['interests'] as List?)
              ?.map((item) => item.toString())
              .toList() ??
          const [],
      imageUrl: json['imageUrl'] as String? ?? '',
      distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 1.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'location': location,
      'bio': bio,
      'interests': interests,
      'imageUrl': imageUrl,
      'distanceKm': distanceKm,
    };
  }
}
