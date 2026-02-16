import 'package:att_school/core/utils/helper/backend_message_helper.dart';
import 'package:att_school/features/admin/subject/delete/data/delete_subject_service.dart';
import 'package:flutter/material.dart';

class DeleteSubjectProvider extends ChangeNotifier {
  final DeleteSubjectService service;
  bool _isLoading = false;
  String? _error;

  DeleteSubjectProvider(this.service);

  bool get isLoading => _isLoading;

  String? get error => _error;

  Future<BackendMessageHelper> deleteSubject(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await service.deleteSubject(id);

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
