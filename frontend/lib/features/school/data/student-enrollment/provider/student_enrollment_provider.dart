import 'package:att_school/features/school/master/class/read/detail/provider/read_class_detail_provider.dart';
import 'package:att_school/features/school/master/semester/read/detail/provider/read_semester_active_provider.dart';
import 'package:att_school/features/school/data/student-enrollment/data/student_enrollment_model.dart';
import 'package:flutter/material.dart';

class StudentEnrollmentProvider extends ChangeNotifier {
  final ReadClassDetailProvider class_;
  final ReadSemesterActiveProvider semester;

  StudentEnrollmentProvider(this.class_, this.semester);

  Future<StudentEnrollmentModel?> getActive(
    List<StudentEnrollmentModel> data,
  ) async {
    StudentEnrollmentModel? result;

    final semesterActive = await semester.fetchActive();

    if (semesterActive == null) return null;

    for (final item in data) {
      if (item.semesterId == semesterActive.id) {
        await class_.fetchById(item.classId);

        result = StudentEnrollmentModel.fromJson({
          ...item.toMap(),
          'class': class_.data,
          'semester': semesterActive,
          'academicYear': semester.academicYear,
        });
      }
    }

    if (result != null) return result;

    return StudentEnrollmentModel.fromJson({
      'semester': semesterActive,
      'academicYear': semester.academicYear,
    });
  }
}
