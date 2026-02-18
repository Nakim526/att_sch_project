import 'package:att_school/core/constant/string/app_string.dart';
import 'package:dio/dio.dart';

class ReadSemesterService {
  final Dio dio;

  ReadSemesterService(this.dio);

  Future<Response> readSemesterList() async {
    return await dio.get(AppString.semesterUrl);
  }

  Future<Response> readSemesterDetail(String id) async {
    return await dio.get("${AppString.semesterUrl}/$id");
  }
}
