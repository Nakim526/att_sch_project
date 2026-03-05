import 'package:att_school/features/school/master/teacher/models/teacher_model.dart';

class ClassTeacherModel {
  final String? id;
  final String? classId;
  final String? teacherId;
  final TeacherModel? teacher;

  ClassTeacherModel({
    this.id,
    this.classId,
    this.teacherId,
    this.teacher,
  });

  factory ClassTeacherModel.fromJson(Map<String, dynamic> json) {
    return ClassTeacherModel(
      id: json['id'],
      classId: json['classId'],
      teacherId: json['teacherId'],
      teacher: TeacherModel.fromJson(json['teacher']),
    );
  }
}
