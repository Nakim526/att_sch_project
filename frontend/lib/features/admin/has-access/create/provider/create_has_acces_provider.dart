import 'package:att_school/core/utils/helper/backend_message_helper.dart';
import 'package:att_school/features/admin/has-access/create/data/create_has_access_service.dart';
import 'package:att_school/features/admin/has-access/models/has_access_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CreateHasAccessProvider extends ChangeNotifier {
  final CreateHasAccessService service;
  bool _isLoading = false;
  String _error = '';

  CreateHasAccessProvider(this.service);

  bool get isLoading => _isLoading;

  Future<BackendMessageHelper> createHasAccess(HasAccessModel payload) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await service.createHasAccess(payload.toJson());

      final message = response.data['message'].toString();
      final data = response.data['data'];

      return BackendMessageHelper(true, message: message, data: data);
    } on DioException catch (e) {
      if (e.response?.statusCode == null) {
        _error = e.message.toString();
      } else {
        _error = "${e.response?.statusCode} - ${e.response?.data['message']}";
      }
      
      debugPrint(_error);

      return BackendMessageHelper(false, message: _error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
