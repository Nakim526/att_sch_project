import 'package:att_school/core/constant/string/app_string.dart';
import 'package:dio/dio.dart';

class DeleteStudentService {
  final Dio dio;

  DeleteStudentService(this.dio);

  Future<Response> deleteStudent(String id, CancelToken? cancelToken) async {
    return await dio.delete(
      '${AppString.studentUrl}/$id',
      cancelToken: cancelToken,
    );
  }

  Future<Response> deleteForceStudent(
    String id,
    CancelToken? cancelToken,
  ) async {
    return await dio.delete(
      '${AppString.studentUrl}/delete/$id',
      cancelToken: cancelToken,
    );
  }
}
