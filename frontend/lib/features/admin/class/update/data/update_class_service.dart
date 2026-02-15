import 'package:att_school/core/constant/string/app_string.dart';
import 'package:dio/dio.dart';

class UpdateClassService {
  final Dio dio;

  UpdateClassService(this.dio);

  Future<Response> updateClass(
    String id, {
    required Map<String, dynamic> payload,
  }) async {
    return await dio.put('${AppString.classUrl}/$id', data: payload);
  }
}
