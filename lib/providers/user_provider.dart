// lib/providers/user_provider.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  String? _token;

  UserModel? get user => _user;
  String? get token => _token;

  bool get isLoggedIn => _user != null && _token != null;

  Future<void> setUser(UserModel user, {String? token}) async {
    _user = user;
    if (token != null) _token = token;
    notifyListeners();

    // persist to disk
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user', jsonEncode(user.toJson()));
    if (token != null) prefs.setString('token', token);
  }

  Future<void> clearUser() async {
    _user = null;
    _token = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    await prefs.remove('token');
  }

  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    final token = prefs.getString('token');

    if (userJson != null) {
      try {
        final map = jsonDecode(userJson) as Map<String, dynamic>;
        _user = UserModel.fromJson(map);
      } catch (e) {
        _user = null;
      }
    }

    _token = token;
    notifyListeners();
  }
}
