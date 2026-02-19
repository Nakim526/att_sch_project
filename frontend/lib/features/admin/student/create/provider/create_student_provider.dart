import 'package:att_school/core/utils/helper/backend_message_helper.dart';
import 'package:att_school/features/admin/student/create/data/create_student_service.dart';
import 'package:att_school/features/admin/student/models/student_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CreateStudentProvider extends ChangeNotifier {
  final CreateStudentService service;
  bool _isLoading = false;
  String _error = '';

  CreateStudentProvider(this.service);

  bool get isLoading => _isLoading;

  Future<BackendMessageHelper> createStudent(StudentModel payload) async {
    _isLoading = true;
    notifyListeners();

    try {
      final req = payload.toJson();

      debugPrint(req.toString());

      final response = await service.createStudent(payload.toJson());

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
