import 'package:att_school/core/constant/string/app_string.dart';
import 'package:dio/dio.dart';

class SchoolService {
  final Dio dio;

  SchoolService(this.dio);

  Future<Response> getCurrent(CancelToken? cancelToken) async {
    return await dio.get('${AppString.schoolUrl}/me', cancelToken: cancelToken);
  }
}
