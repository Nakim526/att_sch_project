import 'package:att_school/core/utils/helper/backend_message_helper.dart';
import 'package:att_school/features/admin/class/models/class_model.dart';
import 'package:att_school/features/admin/class/update/data/update_class_service.dart';
import 'package:flutter/material.dart';

class UpdateClassProvider extends ChangeNotifier {
  final UpdateClassService service;
  bool _isLoading = false;
  String? _error;

  UpdateClassProvider(this.service);

  bool get isLoading => _isLoading;

  String? get error => _error;

  Future<BackendMessageHelper> updateClass(ClassModel? payload) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await service.updateClass(
        payload!.id!,
        payload: payload.toJson(),
      );

      final message = response.data['message'].toString();
      final data = response.data['data'];

      return BackendMessageHelper(true, message: message, data: data);
    } catch (e) {
      debugPrint(e.toString());
      return BackendMessageHelper(false, message: e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
