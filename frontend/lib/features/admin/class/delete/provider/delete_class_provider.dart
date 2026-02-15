import 'package:att_school/core/utils/helper/backend_message_helper.dart';
import 'package:att_school/features/admin/class/delete/data/delete_class_service.dart';
import 'package:flutter/material.dart';

class DeleteClassProvider extends ChangeNotifier {
  final DeleteClassService service;
  bool _isLoading = false;
  String? _error;

  DeleteClassProvider(this.service);

  bool get isLoading => _isLoading;

  String? get error => _error;

  Future<BackendMessageHelper> deleteClass(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await service.deleteClass(id);

      return BackendMessageHelper(
        response.statusCode == 200,
        message: response.statusMessage,
      );
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
