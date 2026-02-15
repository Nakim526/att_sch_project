import 'package:att_school/core/constant/string/app_string.dart';
import 'package:dio/dio.dart';

class ReadHasAccessService {
  final Dio dio;

  ReadHasAccessService(this.dio);

  Future<Response> readHasAccessList() async {
    return await dio.get(AppString.hasAccessUrl);
  }

  Future<Response> readHasAccessDetail(String id) async {
    return await dio.get('${AppString.hasAccessUrl}/$id');
  }
}
