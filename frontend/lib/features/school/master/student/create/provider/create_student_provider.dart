import 'package:att_school/core/utils/helper/backend/backend_message_helper.dart';
import 'package:att_school/core/utils/helper/backend/error_exception_helper.dart';
import 'package:att_school/features/school/master/student/create/data/create_student_service.dart';
import 'package:att_school/features/school/master/student/models/student_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CreateStudentProvider extends ChangeNotifier {
  final CancelToken _cancelToken = CancelToken();
  final CreateStudentService service;
  bool _isLoading = false;
  bool _disposed = false;
  String _error = '';

  CreateStudentProvider(this.service);

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

  Future<BackendMessageHelper> createStudent(StudentModel payload) async {
    _isLoading = true;
    notifyListeners();

    try {
      // return PayloadDebugHelper.show(payload);
      final response = await service.createStudent(
        payload.toJson(),
        _cancelToken,
      );

      final message = response.data['message'].toString();
      final data = response.data['data'];

      return BackendMessageHelper(true, message: message, data: data);
    } on DioException catch (e) {
      _error = ErrorExceptionHelper(e, 'Siswa').toString();

      debugPrint(_error);

      return BackendMessageHelper(false, message: _error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
