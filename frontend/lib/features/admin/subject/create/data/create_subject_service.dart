import 'package:att_school/core/constant/string/app_string.dart';
import 'package:dio/dio.dart';

class CreateSubjectService {
  final Dio dio;

  CreateSubjectService(this.dio);

  Future<Response> createSubject(Map<String, dynamic> data) async {
    return await dio.post(AppString.subjectUrl, data: data);
  }
}
