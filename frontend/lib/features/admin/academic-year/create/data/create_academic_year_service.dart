import 'package:att_school/core/constant/string/app_string.dart';
import 'package:dio/dio.dart';

class CreateAcademicYearService {
  final Dio dio;

  CreateAcademicYearService(this.dio);

  Future<Response> createAcademicYear(Map<String, dynamic> data) async {
    return await dio.post(AppString.academicYearUrl, data: data);
  }
}
