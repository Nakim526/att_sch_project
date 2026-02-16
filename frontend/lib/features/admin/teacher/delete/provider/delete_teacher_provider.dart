import 'package:att_school/core/utils/helper/backend_message_helper.dart';
import 'package:att_school/features/admin/teacher/delete/data/delete_teacher_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DeleteTeacherProvider extends ChangeNotifier {
  final DeleteTeacherService service;
  bool _isLoading = false;
  String? _error;

  DeleteTeacherProvider(this.service);

  bool get isLoading => _isLoading;

  Future<BackendMessageHelper> deleteTeacher(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await service.deleteTeacher(id);

      return BackendMessageHelper(
        response.statusCode == 200,
        message: response.data['message'],
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == null) {
        _error = e.message.toString();
      } else {
        _error = "${e.response?.statusCode} - ${e.response?.data['message']}";
        debugPrint(_error);
      }

      return BackendMessageHelper(false, message: _error);
    } catch (e) {
      _error = e.toString();
      debugPrint(_error);

      return BackendMessageHelper(false, message: _error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
