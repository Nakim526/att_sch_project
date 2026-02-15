import 'package:att_school/core/constant/string/app_string.dart';
import 'package:dio/dio.dart';

class DeleteHasAccessService {
  final Dio dio;

  DeleteHasAccessService(this.dio);

  Future<Response> deleteHasAccess(String id) async {
    return await dio.delete('${AppString.hasAccessUrl}/$id');
  }
}
