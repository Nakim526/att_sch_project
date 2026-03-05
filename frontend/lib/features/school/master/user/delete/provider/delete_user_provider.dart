import 'package:att_school/core/utils/helper/backend/backend_message_helper.dart';
import 'package:att_school/core/utils/helper/backend/error_exception_helper.dart';
import 'package:att_school/features/school/master/user/delete/data/delete_user_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DeleteUserProvider extends ChangeNotifier {
  final CancelToken _cancelToken = CancelToken();
  final DeleteUserService service;
  bool _isLoading = false;
  bool _disposed = false;
  String _error = '';

  DeleteUserProvider(this.service);

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

  Future<BackendMessageHelper> deleteUser(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await service.deleteUser(id, _cancelToken);

      return BackendMessageHelper(
        response.statusCode == 200,
        message: response.data['message'],
      );
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
