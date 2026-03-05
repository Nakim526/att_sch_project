import 'package:att_school/features/school/master/academic-year/models/academic_year_model.dart';
import 'package:att_school/features/school/master/class/models/class_model.dart';
import 'package:att_school/features/school/master/semester/models/semester_model.dart';

class StudentEnrollmentModel {
  String id;
  String classId;
  String semesterId;
  ClassModel? class_;
  SemesterModel? semester;
  AcademicYearModel? academicYear;

  StudentEnrollmentModel({
    required this.id,
    required this.classId,
    required this.semesterId,
    this.class_,
    this.semester,
    this.academicYear,
  });

  factory StudentEnrollmentModel.fromJson(Map<String, dynamic> json) {
    return StudentEnrollmentModel(
      id: json['id'] ?? '',
      classId: json['classId'] ?? '',
      semesterId: json['semesterId'] ?? '',
      class_: json['class'],
      semester: json['semester'],
      academicYear: json['academicYear'],
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'classId': classId,
    'semesterId': semesterId,
  };
}
