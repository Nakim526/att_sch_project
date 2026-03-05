import 'package:att_school/core/utils/helper/backend/backend_message_helper.dart';
import 'package:att_school/core/utils/helper/backend/error_exception_helper.dart';
import 'package:att_school/features/school/master/academic-year/delete/data/delete_academic_year_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DeleteAcademicYearProvider extends ChangeNotifier {
  final CancelToken _cancelToken = CancelToken();
  final DeleteAcademicYearService service;
  bool _isLoading = false;
  bool _disposed = false;
  String _error = '';

  DeleteAcademicYearProvider(this.service);

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

  Future<BackendMessageHelper> deleteAcademicYear(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await service.deleteAcademicYear(id, _cancelToken);

      return BackendMessageHelper(
        response.statusCode == 200,
        message: response.statusMessage,
      );
    } on DioException catch (e) {
      _error = ErrorExceptionHelper(e, 'Tahun Ajaran').toString();

      debugPrint(_error);

      return BackendMessageHelper(false, message: _error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
