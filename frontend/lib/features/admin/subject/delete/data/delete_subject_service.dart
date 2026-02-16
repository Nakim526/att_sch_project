import 'package:att_school/core/constant/string/app_string.dart';
import 'package:dio/dio.dart';

class DeleteSubjectService {
  final Dio dio;

  DeleteSubjectService(this.dio);

  Future<Response> deleteSubject(String id) async {
    return await dio.delete('${AppString.subjectUrl}/$id');
  }
}
