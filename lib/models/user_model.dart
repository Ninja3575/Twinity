// lib/models/user_model.dart
class UserModel {
  final String id;
  final String name;
  final String email;
  final String avatarUrl; // optional

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl = '',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] ?? json['user_id'] ?? '').toString(),
      name: json['name'] ?? json['fullName'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: json['avatar'] ?? json['avatarUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'avatar': avatarUrl,
  };
}
