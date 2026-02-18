import 'package:att_school/core/utils/formatter/backend_formatter.dart';
import 'package:att_school/core/utils/helper/backend_message_helper.dart';
import 'package:att_school/features/admin/teacher/models/teacher_model.dart';
import 'package:att_school/features/admin/teacher/read/data/read_teacher_service.dart';
import 'package:att_school/features/school/provider/school_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ReadTeacherDetailProvider extends ChangeNotifier {
  final ReadTeacherService service;
  final SchoolProvider provider;
  TeacherModel? _teacher;
  bool _isLoading = false;
  String _error = '';
  String? _id;

  ReadTeacherDetailProvider(this.service, this.provider);

  bool get isLoading => _isLoading;

  String get error => _error;

  TeacherModel? get teacher => _teacher;

  Future<BackendMessageHelper> fetchById(String id) async {
    _id = id;
    _error = '';
    _teacher = null;
    _isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> data = {};
      final response = await service.readTeacherDetail(id);
      final school = await provider.getSchoolName();

      data = response.data['data'];
      data['school'] = school;

      _teacher = TeacherModel.fromJson(data);

      return BackendMessageHelper(true, data: _teacher);
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
