import 'package:att_school/core/utils/helper/backend_message_helper.dart';
import 'package:att_school/features/admin/has-access/models/has_access_model.dart';
import 'package:att_school/features/admin/has-access/read/data/read_has_access_service.dart';
import 'package:att_school/features/school/provider/school_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ReadHasAccessDetailProvider extends ChangeNotifier {
  final ReadHasAccessService service;
  final SchoolProvider schoolProvider;
  HasAccessModel? _hasAccess;
  bool _isLoading = false;
  String? _error;
  String? _id;

  ReadHasAccessDetailProvider(this.service, this.schoolProvider);

  bool get isLoading => _isLoading;

  HasAccessModel? get hasAccess => _hasAccess;

  Future<BackendMessageHelper> fetchById(String id) async {
    _id = id;
    _error = null;
    _hasAccess = null;
    _isLoading = true;
    notifyListeners();

    try {
      final response = await service.readHasAccessDetail(id);

      _hasAccess = HasAccessModel.fromJson(response.data['data']);

      final message = response.data['message'].toString();

      return BackendMessageHelper(true, message: message, data: _hasAccess);
    } on DioException catch (e) {
      _error = "${e.response?.statusCode} - ${e.response?.data['message']}";
      debugPrint(_error);

      return BackendMessageHelper(false, message: _error);
    } catch (e) {
      _error = e.toString();
      debugPrint(_error);

      return BackendMessageHelper(false, message: _error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reload() => fetchById(_id!);
}
