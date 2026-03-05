import 'package:att_school/core/utils/helper/backend/backend_message_helper.dart';
import 'package:att_school/core/utils/helper/backend/error_exception_helper.dart';
import 'package:att_school/features/school/master/class/delete/data/delete_class_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DeleteClassProvider extends ChangeNotifier {
  final CancelToken _cancelToken = CancelToken();
  final DeleteClassService service;
  bool _isLoading = false;
  bool _disposed = false;
  String _error = '';

  DeleteClassProvider(this.service);

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

  Future<BackendMessageHelper> deleteClass(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await service.deleteClass(id, _cancelToken);

      return BackendMessageHelper(
        response.statusCode == 200,
        message: response.statusMessage,
      );
    } on DioException catch (e) {
      _error = ErrorExceptionHelper(e, 'Kelas').toString();

      debugPrint(_error);

      return BackendMessageHelper(false, message: _error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
