import 'package:att_school/core/constant/string/app_string.dart';
import 'package:dio/dio.dart';

class UpdateTeacherService {
  final Dio dio;

  UpdateTeacherService(this.dio);

  Future<Response> updateTeacher(
    String id, {
    required Map<String, dynamic> payload,
  }) async {
    return await dio.put('${AppString.teacherUrl}/$id', data: payload);
  }
}
