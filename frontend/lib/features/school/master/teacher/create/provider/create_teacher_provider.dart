import 'package:att_school/core/utils/helper/backend/backend_message_helper.dart';
import 'package:att_school/core/utils/helper/backend/error_exception_helper.dart';
import 'package:att_school/features/school/master/teacher/create/data/create_teacher_service.dart';
import 'package:att_school/features/school/master/teacher/models/teacher_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CreateTeacherProvider extends ChangeNotifier {
  final CancelToken _cancelToken = CancelToken();
  final CreateTeacherService service;
  bool _isLoading = false;
  bool _disposed = false;
  String _error = '';

  CreateTeacherProvider(this.service);

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

  Future<BackendMessageHelper> createTeacher(TeacherModel payload) async {
    _isLoading = true;
    notifyListeners();

    try {
      // return PayloadDebugHelper(payload.toJson()).show();
      debugPrint(payload.toJson().toString());
      final response = await service.createTeacher(
        payload.toJson(),
        _cancelToken,
      );

      final data = response.data['data'];

      final message = response.data['message'].toString();

      return BackendMessageHelper(true, message: message, data: data);
    } on DioException catch (e) {
      _error = ErrorExceptionHelper(e, 'Guru').toString();

      debugPrint(_error);

      return BackendMessageHelper(false, message: _error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
