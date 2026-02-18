import 'package:att_school/core/constant/string/app_string.dart';
import 'package:dio/dio.dart';

class ReadAcademicYearService {
  final Dio dio;

  ReadAcademicYearService(this.dio);

  Future<Response> readAcademicYearList() async {
    return await dio.get(AppString.academicYearUrl);
  }

  Future<Response> readAcademicYearDetail(String id) async {
    return await dio.get("${AppString.academicYearUrl}/$id");
  }
}
