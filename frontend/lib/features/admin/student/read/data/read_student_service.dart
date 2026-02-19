import 'package:att_school/core/constant/string/app_string.dart';
import 'package:dio/dio.dart';

class ReadStudentService {
  final Dio dio;

  ReadStudentService(this.dio);

  Future<Response> readStudentList() async {
    return await dio.get(AppString.studentUrl);
  }

  Future<Response> readStudentDetail(String id) async {
    return await dio.get("${AppString.studentUrl}/$id");
  }
}
