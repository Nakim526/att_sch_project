import 'package:att_school/core/constant/string/app_string.dart';
import 'package:dio/dio.dart';

class ReadClassService {
  final Dio dio;

  ReadClassService(this.dio);

  Future<Response> readClassList() async {
    return await dio.get(AppString.classUrl);
  }

  Future<Response> readClassDetail(String id) async {
    return await dio.get("${AppString.classUrl}/$id");
  }
}
