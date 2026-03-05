import 'package:att_school/core/utils/helper/backend/backend_message_helper.dart';
import 'package:att_school/core/utils/helper/backend/error_exception_helper.dart';
import 'package:att_school/features/school/data/class-schedule/data/class_schedule_model.dart';
import 'package:att_school/features/school/data/teaching-assignment/data/teaching_assignment_model.dart';
import 'package:att_school/features/school/master/class/models/class_model.dart';
import 'package:att_school/features/school/master/class/read/data/read_class_service.dart';
import 'package:att_school/features/school/data/class-teacher/provider/class_teacher_provider.dart';
import 'package:att_school/features/school/master/student/models/student_model.dart';
import 'package:att_school/features/school/master/subject/models/subject_model.dart';
import 'package:att_school/features/school/master/subject/read/data/read_subject_service.dart';
import 'package:att_school/features/school/public/provider/school_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ReadClassDetailProvider extends ChangeNotifier {
  final CancelToken _cancelToken = CancelToken();
  final ReadClassService service;
  final ReadSubjectService provider;
  final SchoolProvider school;
  final ClassTeacherProvider classTeacher;
  ClassModel? _class;
  bool _isLoading = false;
  bool _disposed = false;
  bool _isReady = false;
  String _error = '';
  String? _id;

  ReadClassDetailProvider(
    this.service,
    this.provider,
    this.school,
    this.classTeacher,
  );

  ClassModel? get data => _class;

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

  Future<BackendMessageHelper> fetchById(String id, {String? teacherId}) async {
    _id = id;
    _error = '';
    _class = null;
    _isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> data = {};
      List<StudentModel> enrollments = [];
      List<TeachingAssignmentModel> assignments = [];

      final response = await service.readClassDetail(id, _cancelToken);
      await school.getName();

      data = response.data['data'];

      final classTeacherData = await classTeacher.getActive(
        data['classTeachers'],
      );

      debugPrint("TEACHER ID: ${teacherId ?? 'Bukan Guru'}");

      if (teacherId != null && data['teachingAssignments'].isNotEmpty) {
        for (final assignment in data['teachingAssignments']) {
          if (assignment['teacherId'] == teacherId) {
            final subjects = await provider.readSubjectDetail(
              assignment['subjectId'],
              _cancelToken,
            );

            List<ClassScheduleModel> schedules = [];
            for (final schedule in assignment['schedules']) {
              schedules.add(ClassScheduleModel.fromJson({...schedule}));
            }

            assignments.add(
              TeachingAssignmentModel.fromJson({
                ...assignment,
                'subject': SubjectModel.fromJson(subjects.data['data']),
                'schedules': schedules,
              }),
            );
          }
        }
      }

      if (data['enrollments'].isNotEmpty) {
        for (final enrollment in data['enrollments']) {
          enrollments.add(StudentModel.fromJson(enrollment['student']));
        }
      }

      data['school'] = school.name;
      data['teacher'] = classTeacherData?.teacher;
      data['enrollments'] = enrollments;
      data['assignments'] = assignments;

      _class = ClassModel.fromJson(data);

      return BackendMessageHelper(true, data: _class);
    } on DioException catch (e) {
      _error = ErrorExceptionHelper(e, 'Kelas').toString();

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
