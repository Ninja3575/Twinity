// lib/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthService {
  final String baseUrl;

  AuthService({required this.baseUrl});

  /// Replace body & endpoint according to your backend.
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      // Expecting something like { "token": "...", "user": {...} }
      return json;
    } else {
      throw Exception('Login failed: ${response.statusCode} ${response.body}');
    }
  }

  /// Example fetch profile using token
  Future<UserModel> fetchProfile(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/profile'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return UserModel.fromJson(json as Map<String, dynamic>);
    } else {
      throw Exception('Failed to fetch profile');
    }
  }
}
