import 'package:att_school/core/constant/string/app_string.dart';
import 'package:dio/dio.dart';

class UpdateSemesterService {
  final Dio dio;

  UpdateSemesterService(this.dio);

  Future<Response> updateSemester(
    String id, {
    required Map<String, dynamic> payload,
  }) async {
    return await dio.put('${AppString.semesterUrl}/$id', data: payload);
  }
}
