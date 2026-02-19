import 'package:att_school/core/utils/formatter/backend_formatter.dart';
import 'package:att_school/core/utils/helper/backend_message_helper.dart';
import 'package:att_school/features/auth/data/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService service;
  bool _isLoading = false;
  String _error = '';

  AuthProvider(this.service);

  bool get isLoading => _isLoading;

  Future<BackendMessageHelper> login() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await service.login();

      if (response.statusCode != 200) {
        return BackendMessageHelper(false, message: response.statusMessage);
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('roles', response.data['user']['roles'].toString());

      return BackendMessageHelper(true);
    } on DioException catch (e) {
      if (e.response?.statusCode != null) {
        String message = e.response?.data['message'];
        message = BackendFormatter.isNotFound(message);

        _error = "${e.response?.statusCode} - $message";
      } else {
        _error = e.message.toString();
      }

      debugPrint(_error);

      return BackendMessageHelper(false, message: _error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await service.logout();
    notifyListeners();
  }
}
