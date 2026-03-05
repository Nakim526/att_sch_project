import 'package:att_school/core/utils/helper/backend/backend_message_helper.dart';
import 'package:att_school/core/utils/helper/backend/error_exception_helper.dart';
import 'package:att_school/features/school/master/user/create/data/create_user_service.dart';
import 'package:att_school/features/school/master/user/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CreateUserProvider extends ChangeNotifier {
  final CancelToken _cancelToken = CancelToken();
  final CreateUserService service;
  bool _isLoading = false;
  bool _disposed = false;
  String _error = '';

  CreateUserProvider(this.service);

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

  Future<BackendMessageHelper> createUser(UserModel payload) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await service.createUser(payload.toJson(), _cancelToken);

      final message = response.data['message'].toString();
      final data = response.data['data'];

      debugPrint(data.toString());

      return BackendMessageHelper(true, message: message, data: data);
    } on DioException catch (e) {
      _error = ErrorExceptionHelper(e, 'Hak Akses').toString();

      debugPrint(_error);

      return BackendMessageHelper(false, message: _error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
