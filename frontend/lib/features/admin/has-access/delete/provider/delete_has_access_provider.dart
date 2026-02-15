import 'package:att_school/core/utils/helper/backend_message_helper.dart';
import 'package:att_school/features/admin/has-access/delete/data/delete_has_access_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DeleteHasAccessProvider extends ChangeNotifier {
  final DeleteHasAccessService service;
  bool _isLoading = false;
  String? _error;

  DeleteHasAccessProvider(this.service);

  bool get isLoading => _isLoading;

  Future<BackendMessageHelper> deleteHasAccess(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await service.deleteHasAccess(id);

      return BackendMessageHelper(
        response.statusCode == 200,
        message: response.data['message'],
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == null) {
        _error = e.message.toString();
      } else {
        _error = "${e.response?.statusCode} - ${e.response?.data['message']}";
        debugPrint(_error);
      }

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
}
