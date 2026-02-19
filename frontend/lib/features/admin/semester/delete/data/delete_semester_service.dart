import 'package:att_school/core/constant/string/app_string.dart';
import 'package:dio/dio.dart';

class DeleteSemesterService {
  final Dio dio;

  DeleteSemesterService(this.dio);

  Future<Response> deleteSemester(String id) async {
    return await dio.delete('${AppString.semesterUrl}/$id');
  }
}
