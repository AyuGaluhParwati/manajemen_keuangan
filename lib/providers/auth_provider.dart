import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLogin = false;

  bool get isLogin => _isLogin;

  Future<void> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    _isLogin = prefs.getBool("login") ?? false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    if (email == "admin@gmail.com" &&
        password == "123456") {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setBool("login", true);

      _isLogin = true;

      notifyListeners();

      return true;
    }

    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();

    _isLogin = false;

    notifyListeners();
  }
}