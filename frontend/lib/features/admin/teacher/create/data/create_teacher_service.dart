import 'package:att_school/core/constant/string/app_string.dart';
import 'package:dio/dio.dart';

class CreateTeacherService {
  final Dio dio;

  CreateTeacherService(this.dio);

  Future<Response> createTeacher(Map<String, dynamic> data) async {
    return await dio.post(AppString.teacherUrl, data: data);
  }
}
