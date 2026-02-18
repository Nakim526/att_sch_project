import 'package:att_school/core/utils/formatter/backend_formatter.dart';
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
  String _error = '';
  String? _id;

  ReadHasAccessDetailProvider(this.service, this.schoolProvider);

  bool get isLoading => _isLoading;

  String get error => _error;

  HasAccessModel? get hasAccess => _hasAccess;

  Future<BackendMessageHelper> fetchById(String id) async {
    _id = id;
    _error = '';
    _hasAccess = null;
    _isLoading = true;
    notifyListeners();

    try {
      final response = await service.readHasAccessDetail(id);

      _hasAccess = HasAccessModel.fromJson(response.data['data']);

      return BackendMessageHelper(true, data: _hasAccess);
    } on DioException catch (e) {
      if (e.response?.statusCode != null) {
        String message = e.response?.data['message'];
        message = BackendFormatter.isNotFound(message);

        _error = "${e.response?.statusCode} - $message";
      } else {
        _error = e.message.toString();
      }

      debugPrint(_error);

      return BackendMessageHelper(false, message: _error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() => _error = '';

  Future<void> reload() => fetchById(_id!);
}
