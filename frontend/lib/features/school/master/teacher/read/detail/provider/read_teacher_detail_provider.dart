import 'package:att_school/core/utils/helper/backend/backend_message_helper.dart';
import 'package:att_school/core/utils/helper/backend/error_exception_helper.dart';
import 'package:att_school/features/school/master/teacher/models/teacher_model.dart';
import 'package:att_school/features/school/master/teacher/read/data/read_teacher_service.dart';
import 'package:att_school/features/school/public/provider/school_provider.dart';
import 'package:att_school/features/school/data/teaching-assignment/provider/teaching_assignment_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ReadTeacherDetailProvider extends ChangeNotifier {
  final CancelToken _cancelToken = CancelToken();
  final ReadTeacherService service;
  final SchoolProvider school;
  final TeachingAssignmentProvider teachingAssignment;
  TeacherModel? _teacher;
  bool _isLoading = false;
  bool _disposed = false;
  bool _isReady = false;
  String _error = '';
  String? _id;

  ReadTeacherDetailProvider(this.service, this.school, this.teachingAssignment);

  bool get isLoading => _isLoading;

  String get error => _error;

  TeacherModel? get data => _teacher;

  bool get isReady => _isReady;

  set ready(bool value) {
    _isReady = value;
    notifyListeners();
  }

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

  Future<BackendMessageHelper> fetchById(String id) async {
    _id = id;
    _error = '';
    _teacher = null;
    _isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> data = {};
      final response = await service.readTeacherDetail(id, _cancelToken);
      await school.getName();

      if (response.data['data'] == null) {
        _error = 'Guru tidak ditemukan';
        return BackendMessageHelper(false, message: _error);
      }

      data = response.data['data'];

      final teachingActive = await teachingAssignment.getActive(
        data['teachingAssignments'],
      );

      data['school'] = school.name;
      data['assignments'] = teachingActive;
      data['semester'] = teachingActive?.first.semester;
      data['academicYear'] = teachingActive?.first.academicYear;

      _teacher = TeacherModel.fromJson(data);

      return BackendMessageHelper(true, data: _teacher);
    } on DioException catch (e) {
      _error = ErrorExceptionHelper(e, 'Guru').toString();

      return BackendMessageHelper(false, message: _error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() => _error = '';

  Future<void> reload() => fetchById(_id!);
}
