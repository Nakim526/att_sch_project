import 'package:att_school/core/utils/helper/backend/backend_message_helper.dart';
import 'package:att_school/core/utils/helper/backend/error_exception_helper.dart';
import 'package:att_school/features/school/master/subject/delete/data/delete_subject_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DeleteSubjectProvider extends ChangeNotifier {
  final CancelToken _cancelToken = CancelToken();
  final DeleteSubjectService service;
  bool _isLoading = false;
  bool _disposed = false;
  String _error = '';

  DeleteSubjectProvider(this.service);

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

  Future<BackendMessageHelper> deleteSubject(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await service.deleteSubject(id, _cancelToken);

      return BackendMessageHelper(
        response.statusCode == 200,
        message: response.statusMessage,
      );
    } on DioException catch (e) {
      _error = ErrorExceptionHelper(e, 'Mata Pelajaran').toString();

      debugPrint(_error);

      return BackendMessageHelper(false, message: _error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
