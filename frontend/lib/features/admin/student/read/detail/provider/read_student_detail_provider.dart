import 'package:att_school/core/utils/formatter/backend_formatter.dart';
import 'package:att_school/core/utils/helper/backend_message_helper.dart';
import 'package:att_school/features/admin/student/models/student_model.dart';
import 'package:att_school/features/admin/student/read/data/read_student_service.dart';
import 'package:att_school/features/school/provider/school_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ReadStudentDetailProvider extends ChangeNotifier {
  final ReadStudentService service;
  final SchoolProvider school;
  StudentModel? _student;
  bool _isLoading = false;
  String _error = '';
  String? _id;

  ReadStudentDetailProvider(this.service, this.school);

  StudentModel? get student => _student;

  bool get isLoading => _isLoading;

  String get error => _error;

  Future<BackendMessageHelper> fetchById(String id) async {
    _id = id;
    _error = '';
    _student = null;
    _isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> data = {};
      final response = await service.readStudentDetail(id);
      final schoolName = await school.getName();

      data = response.data['data'];

      debugPrint(data.toString());

      data['school'] = schoolName;

      _student = StudentModel.fromJson(data);

      return BackendMessageHelper(true, data: _student);
    } on DioException catch (e) {
      if (e.response?.statusCode != null) {
        String message = e.response?.data['message'];
        message = BackendFormatter.isNotFound(message);

        _error = "${e.response?.statusCode} - $message";
      } else {
        _error = e.message.toString();
      }

      debugPrint(_error);

      return BackendMessageHelper(false, message: _error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() => _error = '';

  Future<void> reload() => fetchById(_id!);
}
