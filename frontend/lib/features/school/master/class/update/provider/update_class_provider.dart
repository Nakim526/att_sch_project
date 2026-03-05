import 'package:att_school/core/utils/helper/backend/backend_message_helper.dart';
import 'package:att_school/core/utils/helper/backend/error_exception_helper.dart';
import 'package:att_school/features/school/master/class/models/class_model.dart';
import 'package:att_school/features/school/master/class/update/data/update_class_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class UpdateClassProvider extends ChangeNotifier {
  final CancelToken _cancelToken = CancelToken();
  final UpdateClassService service;
  bool _isLoading = false;
  bool _disposed = false;
  String _error = '';

  UpdateClassProvider(this.service);

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

  Future<BackendMessageHelper> updateClass(ClassModel? payload) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await service.updateClass(
        payload!.id!,
        payload: payload.toJson(),
        cancelToken: _cancelToken,
      );

      final message = response.data['message'].toString();
      final data = response.data['data'];

      return BackendMessageHelper(true, message: message, data: data);
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
