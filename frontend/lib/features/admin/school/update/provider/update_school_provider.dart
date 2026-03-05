import 'package:att_school/core/utils/helper/backend/backend_message_helper.dart';
import 'package:att_school/core/utils/helper/backend/error_exception_helper.dart';
import 'package:att_school/features/admin/school/models/school_model.dart';
import 'package:att_school/features/admin/school/update/data/update_school_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class UpdateSchoolProvider extends ChangeNotifier {
  final CancelToken _cancelToken = CancelToken();
  final UpdateSchoolService service;
  bool _isLoading = false;
  bool _disposed = false;
  String _error = '';

  UpdateSchoolProvider(this.service);

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

  Future<BackendMessageHelper> updateSchool(SchoolModel? payload) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await service.updateSchool(
        payload!.id!,
        payload: payload.toJson(),
        cancelToken: _cancelToken,
      );

      final message = response.data['message'].toString();
      final data = response.data['data']['school'];

      return BackendMessageHelper(true, message: message, data: data);
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
