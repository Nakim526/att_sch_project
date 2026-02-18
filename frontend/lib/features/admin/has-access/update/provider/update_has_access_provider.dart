import 'package:att_school/core/utils/helper/backend_message_helper.dart';
import 'package:att_school/features/admin/has-access/models/has_access_model.dart';
import 'package:att_school/features/admin/has-access/update/data/update_has_access_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class UpdateHasAccessProvider extends ChangeNotifier {
  final UpdateHasAccessService service;
  bool _isLoading = false;
  String _error = '';

  UpdateHasAccessProvider(this.service);

  bool get isLoading => _isLoading;

  Future<BackendMessageHelper> updateHasAccess(HasAccessModel payload) async {
    _isLoading = true;
    notifyListeners();

    try {
      debugPrint(payload.toJson().toString());
      final response = await service.updateHasAccess(
        payload.id!,
        payload: payload.toJson(),
      );

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
