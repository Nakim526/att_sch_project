import 'package:att_school/core/utils/helper/backend_message_helper.dart';
import 'package:att_school/features/admin/subject/create/data/create_subject_service.dart';
import 'package:att_school/features/admin/subject/models/subject_model.dart';
import 'package:flutter/material.dart';

class CreateSubjectProvider extends ChangeNotifier {
  final CreateSubjectService service;
  bool _isLoading = false;
  String? _error;

  CreateSubjectProvider(this.service);

  bool get isLoading => _isLoading;

  Future<BackendMessageHelper> createSubject(SubjectModel payload) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await service.createSubject(payload.toJson());

      final message = response.data['message'].toString();
      final data = response.data['data'];

      return BackendMessageHelper(true, message: message, data: data);
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
