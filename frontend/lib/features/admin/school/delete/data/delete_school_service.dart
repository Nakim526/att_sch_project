import 'package:att_school/core/constant/string/app_string.dart';
import 'package:dio/dio.dart';

class DeleteSchoolService {
  final Dio dio;

  DeleteSchoolService(this.dio);

  Future<Response> deleteSchool(String id, CancelToken? cancelToken) async {
    return await dio.delete(
      '${AppString.schoolUrl}/$id',
      cancelToken: cancelToken,
    );
  }
}
