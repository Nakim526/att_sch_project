import 'package:att_school/core/constant/string/app_string.dart';
import 'package:dio/dio.dart';

class UpdateStudentService {
  final Dio dio;

  UpdateStudentService(this.dio);

  Future<Response> updateStudent(
    String id, {
    required Map<String, dynamic> payload,
  }) async {
    return await dio.put('${AppString.studentUrl}/$id', data: payload);
  }
}
