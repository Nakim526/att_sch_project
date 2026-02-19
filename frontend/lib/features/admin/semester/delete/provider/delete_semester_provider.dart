import 'package:att_school/core/utils/helper/backend_message_helper.dart';
import 'package:att_school/features/admin/semester/delete/data/delete_semester_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DeleteSemesterProvider extends ChangeNotifier {
  final DeleteSemesterService service;
  bool _isLoading = false;
  String _error = '';

  DeleteSemesterProvider(this.service);

  bool get isLoading => _isLoading;

  Future<BackendMessageHelper> deleteSemester(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await service.deleteSemester(id);

      return BackendMessageHelper(
        response.statusCode == 200,
        message: response.statusMessage,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == null) {
        _error = e.message.toString();
      } else {
        _error = "${e.response?.statusCode} - ${e.response?.data['message']}";
      }

      debugPrint(_error);

      return BackendMessageHelper(false, message: _error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
