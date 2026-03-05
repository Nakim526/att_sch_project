import 'package:att_school/core/utils/helper/backend/backend_message_helper.dart';
import 'package:att_school/core/utils/helper/backend/error_exception_helper.dart';
import 'package:att_school/core/utils/helper/backend/payload_debug_helper.dart';
import 'package:att_school/features/auth/data/auth_model.dart';
import 'package:att_school/features/auth/data/auth_service.dart';
import 'package:att_school/features/auth/roles/provider/roles_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final CancelToken _cancelToken = CancelToken();
  final AuthService service;
  bool _isLoading = false;
  bool _disposed = false;
  String _error = '';

  AuthProvider(this.service);

  bool get isLoading => _isLoading;

  @override
  void dispose() {
    _disposed = true;
    _cancelToken.cancel('Page disposed');
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  Future<BackendMessageHelper> login(AuthModel payload) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await service.login(payload.toString(), _cancelToken);

      // return PayloadDebugHelper(response).show();

      if (response.statusCode != 200) {
        return BackendMessageHelper(false, message: response.statusMessage);
      }

      if (!await RolesProvider.setRoles(response.data['user']['roles'])) {
        return BackendMessageHelper(false, message: 'Roles not found');
      }

      return BackendMessageHelper(true);
    } on DioException catch (e) {
      _error = ErrorExceptionHelper(e, 'Akun').toString();

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
