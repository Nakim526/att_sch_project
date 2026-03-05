import 'package:att_school/core/utils/helper/backend/backend_message_helper.dart';
import 'package:att_school/core/utils/helper/backend/error_exception_helper.dart';
import 'package:att_school/features/admin/school/delete/data/delete_school_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DeleteSchoolProvider extends ChangeNotifier {
  bool _disposed = false;
  final CancelToken _cancelToken = CancelToken();
  final DeleteSchoolService service;
  bool _isLoading = false;
  String _error = '';

  DeleteSchoolProvider(this.service);

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

  Future<BackendMessageHelper> deleteSchool(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await service.deleteSchool(id, _cancelToken);

      return BackendMessageHelper(
        response.statusCode == 200,
        message: response.statusMessage,
      );
    } on DioException catch (e) {
      _error = ErrorExceptionHelper(e, 'Sekolah').toString();

      debugPrint(_error);

      return BackendMessageHelper(false, message: _error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
