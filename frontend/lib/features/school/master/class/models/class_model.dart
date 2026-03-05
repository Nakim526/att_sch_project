import 'package:att_school/features/school/data/teaching-assignment/data/teaching_assignment_model.dart';
import 'package:att_school/features/school/master/student/models/student_model.dart';
import 'package:att_school/features/school/master/teacher/models/teacher_model.dart';

class ClassModel {
  final String? id;
  final String name;
  final int grade;
  final String? teacherId;
  final TeacherModel? teacher;
  final String? teacherRole;
  final String? school;
  final String academicYearId;
  final List<StudentModel>? enrollments;
  final List<TeachingAssignmentModel>? assignments;

  ClassModel({
    this.id,
    required this.name,
    required this.grade,
    this.teacherId,
    this.teacher,
    this.teacherRole,
    this.school,
    required this.academicYearId,
    this.enrollments,
    this.assignments,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'],
      name: json['name'],
      grade: json['gradeLevel'],
      teacher: json['teacher'],
      school: json['school'],
      academicYearId: json['academicYearId'],
      enrollments: json['enrollments'],
      assignments: json['assignments'],
    );
  }

  static ClassModel? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;

    return ClassModel(
      id: map['id'],
      name: map['name'],
      grade: map['gradeLevel'] ?? 0,
      academicYearId: map['academicYearId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'gradeLevel': grade,
      'teacherId': teacherId,
      'role': teacherRole,
      'academicYearId': academicYearId,
    };
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'name': name, 'gradeLevel': grade};
  }
}
