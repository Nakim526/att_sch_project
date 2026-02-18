import 'package:att_school/core/utils/helper/backend_message_helper.dart';
import 'package:att_school/features/admin/teacher/create/data/create_teacher_service.dart';
import 'package:att_school/features/admin/teacher/models/teacher_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CreateTeacherProvider extends ChangeNotifier {
  final CreateTeacherService service;
  bool _isLoading = false;
  String _error = '';

  CreateTeacherProvider(this.service);

  bool get isLoading => _isLoading;

  Future<BackendMessageHelper> createTeacher(TeacherModel payload) async {
    _isLoading = true;
    notifyListeners();

    try {
      debugPrint(payload.toJson().toString());
      final response = await service.createTeacher(payload.toJson());

      final message = response.data['message'].toString();
      final data = response.data['data'];

      return BackendMessageHelper(true, message: message, data: data);
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
