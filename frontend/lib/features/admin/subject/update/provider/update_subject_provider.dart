import 'package:att_school/core/utils/helper/backend_message_helper.dart';
import 'package:att_school/features/admin/subject/models/subject_model.dart';
import 'package:att_school/features/admin/subject/update/data/update_subject_service.dart';
import 'package:flutter/material.dart';

class UpdateSubjectProvider extends ChangeNotifier {
  final UpdateSubjectService service;
  bool _isLoading = false;
  String? _error;

  UpdateSubjectProvider(this.service);

  bool get isLoading => _isLoading;

  String? get error => _error;

  Future<BackendMessageHelper> updateSubject(SubjectModel? payload) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await service.updateSubject(
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
