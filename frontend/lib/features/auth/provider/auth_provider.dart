import 'package:att_school/features/auth/data/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService service;
  bool _isLoading = false;

  AuthProvider(this.service);

  bool get isLoading => _isLoading;

  Future<bool> login() async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await service.login();

      if (result != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('roles', result['roles'].toString());

        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    service.logout();
    notifyListeners();
  }
}
