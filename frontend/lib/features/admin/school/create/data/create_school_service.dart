import 'package:att_school/core/constant/string/app_string.dart';
import 'package:dio/dio.dart';

class CreateSchoolService {
  final Dio dio;

  CreateSchoolService(this.dio);

  Future<Response> createSchool(
    Map<String, dynamic> data,
    CancelToken? cancelToken,
  ) async {
    return await dio.post(
      AppString.schoolUrl,
      data: data,
      cancelToken: cancelToken,
    );
  }
}
