import 'package:att_school/core/constant/string/app_string.dart';
import 'package:dio/dio.dart';

class UpdateSubjectService {
  final Dio dio;

  UpdateSubjectService(this.dio);

  Future<Response> updateSubject(
    String id, {
    required Map<String, dynamic> payload,
  }) async {
    return await dio.put('${AppString.subjectUrl}/$id', data: payload);
  }
}
