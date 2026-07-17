import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider extends ChangeNotifier {

  String _name = "Galuh";
  double _budget = 3000000;

  String get name => _name;
  double get budget => _budget;

  ProfileProvider() {
    loadProfile();
  }

  Future<void> loadProfile() async {

    final prefs = await SharedPreferences.getInstance();

    _name = prefs.getString("name") ?? "Galuh";
    _budget = prefs.getDouble("budget") ?? 3000000;

    notifyListeners();
  }

  double remainingBudget(double expense) {
    return _budget - expense;
  }

  // ===========================
  // SISA BUDGET
  // ===========================
  Future<void> saveProfile({
    required String name,
    required double budget,
  }) async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("name", name);
    await prefs.setDouble("budget", budget);

    _name = name;
    _budget = budget;

    notifyListeners();
  }
}