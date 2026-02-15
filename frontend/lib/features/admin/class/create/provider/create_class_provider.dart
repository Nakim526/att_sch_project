import 'package:att_school/core/utils/helper/backend_message_helper.dart';
import 'package:att_school/features/admin/class/create/data/create_class_service.dart';
import 'package:att_school/features/admin/class/models/class_model.dart';
import 'package:flutter/material.dart';

class CreateClassProvider extends ChangeNotifier {
  final CreateClassService service;
  bool _isLoading = false;
  String? _error;

  CreateClassProvider(this.service);

  bool get isLoading => _isLoading;

  Future<BackendMessageHelper> createClass(ClassModel payload) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await service.createClass(payload.toJson());

      return BackendMessageHelper(true, message: response.data['data']);
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
