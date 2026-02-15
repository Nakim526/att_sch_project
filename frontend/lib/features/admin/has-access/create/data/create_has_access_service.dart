import 'package:att_school/core/constant/string/app_string.dart';
import 'package:dio/dio.dart';

class CreateHasAccessService {
  final Dio dio;

  CreateHasAccessService(this.dio);

  Future<Response> createHasAccess(Map<String, dynamic> data) async {
    return await dio.post(AppString.hasAccessUrl, data: data);
  }
}
