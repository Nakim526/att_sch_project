import 'package:att_school/features/admin/school/read/list/provider/read_school_list_provider.dart';
import 'package:att_school/features/school/master/academic-year/read/list/provider/read_academic_year_list_provider.dart';
import 'package:att_school/features/school/master/class/read/list/provider/read_class_list_provider.dart';
import 'package:att_school/features/school/master/user/read/list/provider/read_user_list_provider.dart';
import 'package:att_school/features/school/master/semester/read/list/provider/read_semester_list_provider.dart';
import 'package:att_school/features/school/master/student/read/list/provider/read_student_list_provider.dart';
import 'package:att_school/features/school/master/subject/read/list/provider/read_subject_list_provider.dart';
import 'package:att_school/features/school/master/teacher/read/list/provider/read_teacher_list_provider.dart';
import 'package:att_school/features/school/teacher/my-class/list/provider/read_my_class_list_provider.dart';
import 'package:flutter/material.dart';

class ProviderHelper extends ChangeNotifier {
  final ReadSchoolListProvider readSchoolListProvider;
  final ReadUserListProvider readUserListProvider;
  final ReadAcademicYearListProvider readAcademicYearListProvider;
  final ReadSemesterListProvider readSemesterListProvider;
  final ReadTeacherListProvider readTeacherListProvider;
  final ReadStudentListProvider readStudentListProvider;
  final ReadSubjectListProvider readSubjectListProvider;
  final ReadClassListProvider readClassListProvider;
  final ReadMyClassListProvider readMyClassListProvider;
  bool _disposed = false;

  ProviderHelper(
    this.readSchoolListProvider,
    this.readUserListProvider,
    this.readAcademicYearListProvider,
    this.readSemesterListProvider,
    this.readTeacherListProvider,
    this.readStudentListProvider,
    this.readSubjectListProvider,
    this.readClassListProvider,
    this.readMyClassListProvider,
  );

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  bool get isLoading {
    return (readSchoolListProvider.isLoading ||
        readUserListProvider.isLoading ||
        readAcademicYearListProvider.isLoading ||
        readSemesterListProvider.isLoading ||
        readTeacherListProvider.isLoading ||
        readStudentListProvider.isLoading ||
        readSubjectListProvider.isLoading ||
        readClassListProvider.isLoading ||
        readMyClassListProvider.isLoading);
  }

  Future<void> reload() async {
    await readSchoolListProvider.reload();
    await readUserListProvider.reload();
    await readAcademicYearListProvider.reload();
    await readSemesterListProvider.reload();
    await readTeacherListProvider.reload();
    await readStudentListProvider.reload();
    await readSubjectListProvider.reload();
    await readClassListProvider.reload();
    await readMyClassListProvider.reload();

    _clearError();

    notifyListeners();
  }

  void _clearError() {
    readSchoolListProvider.clearError();
    readUserListProvider.clearError();
    readAcademicYearListProvider.clearError();
    readSemesterListProvider.clearError();
    readTeacherListProvider.clearError();
    readStudentListProvider.clearError();
    readSubjectListProvider.clearError();
    readClassListProvider.clearError();
    readMyClassListProvider.clearError();
  }
}
