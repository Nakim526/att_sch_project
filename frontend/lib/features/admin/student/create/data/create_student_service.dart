import 'package:att_school/core/constant/string/app_string.dart';
import 'package:dio/dio.dart';

class CreateStudentService {
  final Dio dio;

  CreateStudentService(this.dio);

  Future<Response> createStudent(Map<String, dynamic> data) async {
    return await dio.post(AppString.studentUrl, data: data);
  }
}
