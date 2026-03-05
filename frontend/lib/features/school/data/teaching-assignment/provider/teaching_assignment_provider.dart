import 'package:att_school/features/school/data/class-schedule/data/class_schedule_model.dart';
import 'package:att_school/features/school/master/class/read/detail/provider/read_class_detail_provider.dart';
import 'package:att_school/features/school/master/semester/read/detail/provider/read_semester_active_provider.dart';
import 'package:att_school/features/school/master/subject/read/detail/provider/read_subject_detail_provider.dart';
import 'package:att_school/features/school/data/teaching-assignment/data/teaching_assignment_model.dart';
import 'package:flutter/material.dart';

class TeachingAssignmentProvider extends ChangeNotifier {
  final ReadSubjectDetailProvider subject;
  final ReadClassDetailProvider class_;
  final ReadSemesterActiveProvider semester;

  TeachingAssignmentProvider(this.subject, this.class_, this.semester);

  Future<List<TeachingAssignmentModel>?> getActive(List data) async {
    Map<String, TeachingAssignmentModel> result = {};

    final semesterActive = await semester.fetchActive();

    if (semesterActive == null) return null;

    for (final item in data) {
      if (item['semesterId'] == semesterActive.id) {
        final key = '${item['classId']}_${item['subjectId']}';

        await subject.fetchById(item['subjectId']);
        await class_.fetchById(item['classId']);

        final schedules = item['schedules'] as List<dynamic>?;

        result[key] = TeachingAssignmentModel.fromJson({
          ...item,
          'class': class_.data,
          'subject': subject.data,
          'schedules':
              schedules?.map((e) => ClassScheduleModel.fromJson(e)).toList(),
          'semester': semesterActive,
          'academicYear': semester.academicYear,
        });
      }
    }

    if (result.isNotEmpty) return result.values.toList();

    return [
      TeachingAssignmentModel.fromJson({
        'semester': semesterActive,
        'academicYear': semester.academicYear,
      }),
    ];
  }
}
