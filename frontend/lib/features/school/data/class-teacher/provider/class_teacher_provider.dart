import 'package:att_school/features/school/master/teacher/read/data/read_teacher_service.dart';
import 'package:att_school/features/school/data/class-teacher/data/class_teacher_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ClassTeacherProvider extends ChangeNotifier {
  final CancelToken _cancelToken = CancelToken();
  final ReadTeacherService teacher;

  ClassTeacherProvider(this.teacher);

  @override
  void dispose() {
    _cancelToken.cancel('Detail page disposed');
    super.dispose();
  }

  Future<ClassTeacherModel?> getActive(List<dynamic> data) async {
    if (data.isEmpty) return null;

    final teacherId = data.map((e) => e['teacherId']).first;

    final response = await teacher.readTeacherDetail(teacherId, _cancelToken);

    return ClassTeacherModel.fromJson({'teacher': response.data['data']});
  }
}
