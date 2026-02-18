import 'package:att_school/core/utils/helper/backend_message_helper.dart';
import 'package:att_school/features/admin/academic-year/delete/data/delete_academic_year_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DeleteAcademicYearProvider extends ChangeNotifier {
  final DeleteAcademicYearService service;
  bool _isLoading = false;
  String _error = '';

  DeleteAcademicYearProvider(this.service);

  bool get isLoading => _isLoading;

  Future<BackendMessageHelper> deleteAcademicYear(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await service.deleteAcademicYear(id);

      return BackendMessageHelper(
        response.statusCode == 200,
        message: response.statusMessage,
      );
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
