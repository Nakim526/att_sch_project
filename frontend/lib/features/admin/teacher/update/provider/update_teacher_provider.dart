import 'package:att_school/core/utils/helper/backend_message_helper.dart';
import 'package:att_school/features/admin/teacher/models/teacher_model.dart';
import 'package:att_school/features/admin/teacher/update/data/update_teacher_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class UpdateTeacherProvider extends ChangeNotifier {
  final UpdateTeacherService service;
  bool _isLoading = false;
  String? _error;

  UpdateTeacherProvider(this.service);

  bool get isLoading => _isLoading;

  Future<BackendMessageHelper> updateTeacher(TeacherModel payload) async {
    _isLoading = true;
    notifyListeners();

    try {
      debugPrint(payload.toJson().toString());
      final response = await service.updateTeacher(
        payload.id!,
        payload: payload.toJson(),
      );

      final data = response.data['data'];

      return BackendMessageHelper(true, message: data['id']);
    } on DioException catch (e) {
      if (e.response?.statusCode == null) {
        _error = e.message.toString();
        throw e.message.toString();
      } else {
        _error = "${e.response?.statusCode} - ${e.response?.data['message']}";
        debugPrint(_error);
      }

      return BackendMessageHelper(false, message: _error);
    } catch (e) {
      debugPrint(e.toString());
      return BackendMessageHelper(false, message: e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
