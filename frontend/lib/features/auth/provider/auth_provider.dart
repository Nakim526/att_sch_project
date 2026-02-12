import 'package:att_school/features/auth/data/auth_service.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService service;
  bool _isLoading = false;

  AuthProvider(this.service);

  bool get isLoading => _isLoading;

  Future<bool> login() async {
    _isLoading = true;
    notifyListeners();

    try {
      await service.login();
      return true;
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
