import 'package:att_school/core/utils/helper/backend_helper.dart';
import 'package:att_school/features/auth/data/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService service;
  bool _isLoading = false;
  String? _error;

  AuthProvider(this.service);

  bool get isLoading => _isLoading;

  Future<BackendHelper> login() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await service.login();

      if (response.data != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          'roles',
          response.data['user']['roles'].toString(),
        );

        return BackendHelper(true);
      }

      return BackendHelper(false);
    } catch (e) {
      _error = e.toString();
      debugPrint(e.toString());

      return BackendHelper(false, message: _error);
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
