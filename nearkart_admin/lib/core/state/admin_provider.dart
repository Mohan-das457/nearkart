import 'package:flutter/material.dart';

class AdminProvider extends ChangeNotifier {
  String? _token;
  bool get isLoggedIn => _token != null;
  String? get token => _token;

  // Summary stats (populated from API in real app)
  int totalOrders    = 128;
  int pendingOrders  = 14;
  int totalStores    = 12;
  int totalAgents    = 8;
  int totalUsers     = 340;
  double totalRevenue = 48250;

  void login(String token) {
    _token = token;
    notifyListeners();
  }

  void logout() {
    _token = null;
    notifyListeners();
  }
}
