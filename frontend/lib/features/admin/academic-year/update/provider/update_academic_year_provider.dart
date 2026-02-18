import 'package:att_school/core/utils/helper/backend_message_helper.dart';
import 'package:att_school/features/admin/academic-year/models/academic_year_model.dart';
import 'package:att_school/features/admin/academic-year/update/data/update_academic_year_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class UpdateAcademicYearProvider extends ChangeNotifier {
  final UpdateAcademicYearService service;
  bool _isLoading = false;
  String _error = '';

  UpdateAcademicYearProvider(this.service);

  bool get isLoading => _isLoading;

  Future<BackendMessageHelper> updateAcademicYear(AcademicYearModel? payload) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await service.updateAcademicYear(
        payload!.id!,
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
