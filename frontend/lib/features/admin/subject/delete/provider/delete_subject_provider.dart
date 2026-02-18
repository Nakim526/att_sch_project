import 'package:att_school/core/utils/helper/backend_message_helper.dart';
import 'package:att_school/features/admin/subject/delete/data/delete_subject_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DeleteSubjectProvider extends ChangeNotifier {
  final DeleteSubjectService service;
  bool _isLoading = false;
  String _error = '';

  DeleteSubjectProvider(this.service);

  bool get isLoading => _isLoading;

  Future<BackendMessageHelper> deleteSubject(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await service.deleteSubject(id);

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
