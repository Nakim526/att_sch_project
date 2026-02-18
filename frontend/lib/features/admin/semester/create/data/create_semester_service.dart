import 'package:att_school/core/constant/string/app_string.dart';
import 'package:dio/dio.dart';

class CreateSemesterService {
  final Dio dio;

  CreateSemesterService(this.dio);

  Future<Response> createSemester(Map<String, dynamic> data) async {
    return await dio.post(AppString.semesterUrl, data: data);
  }
}
