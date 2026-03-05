import 'package:att_school/features/school/data/class-schedule/data/class_schedule_model.dart';
import 'package:att_school/features/school/master/academic-year/models/academic_year_model.dart';
import 'package:att_school/features/school/master/class/models/class_model.dart';
import 'package:att_school/features/school/master/semester/models/semester_model.dart';
import 'package:att_school/features/school/master/subject/models/subject_model.dart';
import 'package:flutter/cupertino.dart';

class TeachingAssignmentModel {
  String id;
  String? teacherId;
  String subjectId;
  String classId;
  String semesterId;
  SubjectModel? subject;
  ClassModel? class_;
  SemesterModel? semester;
  AcademicYearModel? academicYear;
  List<ClassScheduleModel>? schedules;

  TeachingAssignmentModel({
    required this.id,
    this.teacherId,
    required this.subjectId,
    required this.classId,
    required this.semesterId,
    this.class_,
    this.subject,
    this.schedules,
    this.semester,
    this.academicYear,
  });

  factory TeachingAssignmentModel.fromJson(Map<String, dynamic> json) {
    return TeachingAssignmentModel(
      id: json['id'] ?? '',
      teacherId: json['teacherId'] ?? '',
      subjectId: json['subjectId'] ?? '',
      classId: json['classId'] ?? '',
      semesterId: json['semesterId'] ?? '',
      class_: json['class'],
      subject: json['subject'],
      schedules: json['schedules'] ?? [],
      semester: json['semester'],
      academicYear: json['academicYear'],
    );
  }

  static List<TeachingAssignmentModel> fromData(
    List<Map<String, dynamic>> data,
  ) {
    return data.map((e) => TeachingAssignmentModel.fromJson(e)).toList();
  }

  static List<TeachingAssignmentModel> fromForm({
    required List<Map<String, dynamic>?> class_,
    required List<Map<String, dynamic>?> subject,
    required List<ClassScheduleModel?> schedule,
    required String semesterId,
  }) {
    Map<String, TeachingAssignmentModel> result = {};

    for (int i = 0; i < class_.length; i++) {
      debugPrint("$i: ${schedule[i]!.toJson().toString()}");
      final classData = ClassModel.fromMap(class_[i]);
      final subjectData = SubjectModel.fromMap(subject[i]);

      final key = '${classData!.id}_${subjectData!.id}';

      if (!result.containsKey(key)) {
        result[key] = TeachingAssignmentModel(
          id: '',
          classId: classData.id!,
          subjectId: subjectData.id!,
          schedules: [],
          semesterId: semesterId,
        );
      }

      result[key]?.schedules?.add(schedule[i]!);
    }

    return result.values.toList();
  }

  Map<String, dynamic> toJson() => {
    'classId': classId,
    'subjectId': subjectId,
    'semesterId': semesterId,
    'schedules': schedules?.map((e) => e.toJson()).toList(),
  };

  Map<String, dynamic> toMap() => {
    'class': class_?.name,
    'subject': subject?.name,
    'detail': '',
  };
}
