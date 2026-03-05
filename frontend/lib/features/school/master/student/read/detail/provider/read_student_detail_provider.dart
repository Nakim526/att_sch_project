import 'package:att_school/core/utils/helper/backend/backend_message_helper.dart';
import 'package:att_school/core/utils/helper/backend/error_exception_helper.dart';
import 'package:att_school/features/school/master/student/models/student_model.dart';
import 'package:att_school/features/school/master/student/read/data/read_student_service.dart';
import 'package:att_school/features/school/public/provider/school_provider.dart';
import 'package:att_school/features/school/data/student-enrollment/data/student_enrollment_model.dart';
import 'package:att_school/features/school/data/student-enrollment/provider/student_enrollment_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ReadStudentDetailProvider extends ChangeNotifier {
  final CancelToken _cancelToken = CancelToken();
  final ReadStudentService service;
  final SchoolProvider school;
  final StudentEnrollmentProvider studentEnrollment;
  StudentModel? _student;
  bool _isLoading = false;
  bool _disposed = false;
  bool _isReady = false;
  String _error = '';
  String? _id;

  ReadStudentDetailProvider(this.service, this.school, this.studentEnrollment);

  StudentModel? get data => _student;

  bool get isLoading => _isLoading;

  String get error => _error;

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
    _student = null;
    _isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> data = {};
      List<StudentEnrollmentModel> studentEnrollmentData = [];
      final response = await service.readStudentDetail(id, _cancelToken);
      await school.getName();

      data = response.data['data'];

      for (final item in data['enrollments'] ?? []) {
        studentEnrollmentData.add(StudentEnrollmentModel.fromJson(item));
      }

      final studentActive = await studentEnrollment.getActive(
        studentEnrollmentData,
      );

      data['school'] = school.name;
      data['class'] = studentActive?.class_;
      data['semester'] = studentActive?.semester;
      data['academicYear'] = studentActive?.academicYear;

      _student = StudentModel.fromJson(data);

      return BackendMessageHelper(true, data: _student);
    } on DioException catch (e) {
      _error = ErrorExceptionHelper(e, 'Siswa').toString();

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
