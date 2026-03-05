import 'package:att_school/core/utils/helper/backend/backend_message_helper.dart';
import 'package:att_school/core/utils/helper/backend/error_exception_helper.dart';
import 'package:att_school/features/school/master/semester/models/semester_model.dart';
import 'package:att_school/features/school/master/semester/update/data/update_semester_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class UpdateSemesterProvider extends ChangeNotifier {
  final CancelToken _cancelToken = CancelToken();
  final UpdateSemesterService service;
  bool _isLoading = false;
  bool _disposed = false;
  String _error = '';

  UpdateSemesterProvider(this.service);

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

  Future<BackendMessageHelper> updateSemester(SemesterModel payload) async {
    _isLoading = true;
    notifyListeners();

    try {
      // return PayloadDebugHelper.show(payload.toJson());
      final response = await service.updateSemester(
        payload.id!,
        payload: payload.toJson(),
        cancelToken: _cancelToken,
      );

      final message = response.data['message'].toString();
      final data = response.data['data'];

      return BackendMessageHelper(true, message: message, data: data);
    } on DioException catch (e) {
      _error = ErrorExceptionHelper(e, 'Semester').toString();

      debugPrint(_error);

      return BackendMessageHelper(false, message: _error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
