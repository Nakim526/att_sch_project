import 'package:att_school/core/constant/string/app_string.dart';
import 'package:dio/dio.dart';

class ReadTeacherService {
  final Dio dio;

  ReadTeacherService(this.dio);

  Future<Response> readTeacherList() async {
    return await dio.get(AppString.teacherUrl);
  }

  Future<Response> readTeacherDetail(String id) async {
    return await dio.get('${AppString.teacherUrl}/$id');
  }
}
