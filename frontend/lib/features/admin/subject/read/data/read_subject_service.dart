import 'package:att_school/core/constant/string/app_string.dart';
import 'package:dio/dio.dart';

class ReadSubjectService {
  final Dio dio;

  ReadSubjectService(this.dio);

  Future<Response> readSubjectList() async {
    return await dio.get(AppString.subjectUrl);
  }

  Future<Response> readSubjectDetail(String id) async {
    return await dio.get("${AppString.subjectUrl}/$id");
  }
}
