import 'package:att_school/core/utils/helper/backend/backend_message_helper.dart';
import 'package:att_school/core/utils/helper/backend/error_exception_helper.dart';
import 'package:att_school/features/school/master/subject/models/subject_model.dart';
import 'package:att_school/features/school/master/subject/update/data/update_subject_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class UpdateSubjectProvider extends ChangeNotifier {
  final CancelToken _cancelToken = CancelToken();
  final UpdateSubjectService service;
  bool _isLoading = false;
  bool _disposed = false;
  String _error = '';

  UpdateSubjectProvider(this.service);

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

  Future<BackendMessageHelper> updateSubject(SubjectModel? payload) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await service.updateSubject(
        payload!.id!,
        payload: payload.toJson(),
      );

      final message = response.data['message'].toString();
      final data = response.data['data'];

      return BackendMessageHelper(true, message: message, data: data);
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
