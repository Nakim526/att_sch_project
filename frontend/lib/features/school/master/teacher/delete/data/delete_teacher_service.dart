import 'package:att_school/core/constant/string/app_string.dart';
import 'package:dio/dio.dart';

class DeleteTeacherService {
  final Dio dio;

  DeleteTeacherService(this.dio);

  Future<Response> deleteTeacher(String id, CancelToken? cancelToken) async {
    return await dio.delete(
      '${AppString.teacherUrl}/$id',
      cancelToken: cancelToken,
    );
  }
}
