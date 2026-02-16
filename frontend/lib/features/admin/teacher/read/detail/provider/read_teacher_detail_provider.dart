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
  String? _error;
  String? _id;

  ReadTeacherDetailProvider(this.service, this.provider);

  bool get isLoading => _isLoading;

  TeacherModel? get teacher => _teacher;

  Future<BackendMessageHelper> fetchById(String id) async {
    _id = id;
    _error = null;
    _teacher = null;
    _isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> data = {};
      final response = await service.readTeacherDetail(id);
      final school = await provider.getSchoolName();

      if (response.data != null) {
        data = response.data['data'];
        data['school'] = school;

        _teacher = TeacherModel.fromJson(data);
      }

      return BackendMessageHelper(true, message: _teacher);
    } on DioException catch (e) {
      _error = "${e.response?.statusCode} - ${e.response?.data['message']}";
      debugPrint(_error);

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

  Future<void> reload() => fetchById(_id!);
}
