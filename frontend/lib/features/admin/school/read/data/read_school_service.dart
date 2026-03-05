import 'package:att_school/core/constant/string/app_string.dart';
import 'package:dio/dio.dart';

class ReadSchoolService {
  final Dio dio;

  ReadSchoolService(this.dio);

  Future<Response> readAllSchool(CancelToken? cancelToken) async {
    return await dio.get(AppString.schoolUrl, cancelToken: cancelToken);
  }

  Future<Response> readSchoolById(String id, CancelToken? cancelToken) async {
    return await dio.get(
      '${AppString.schoolUrl}/$id',
      cancelToken: cancelToken,
    );
  }
}
