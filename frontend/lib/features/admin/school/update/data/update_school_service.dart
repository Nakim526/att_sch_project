import 'package:att_school/core/constant/string/app_string.dart';
import 'package:dio/dio.dart';

class UpdateSchoolService {
  final Dio dio;

  UpdateSchoolService(this.dio);

  Future<Response> updateSchool(
    String id, {
    required Map<String, dynamic> payload,
    CancelToken? cancelToken,
  }) async {
    return await dio.put(
      '${AppString.schoolUrl}/$id',
      data: payload,
      cancelToken: cancelToken,
    );
  }
}
