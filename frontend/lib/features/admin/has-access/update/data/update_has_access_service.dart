import 'package:att_school/core/constant/string/app_string.dart';
import 'package:dio/dio.dart';

class UpdateHasAccessService {
  final Dio dio;

  UpdateHasAccessService(this.dio);

  Future<Response> updateHasAccess(
    String id, {
    required Map<String, dynamic> payload,
  }) async {
    return await dio.put('${AppString.hasAccessUrl}/$id', data: payload);
  }
}
