import 'package:att_school/core/utils/formatter/backend_formatter.dart';
import 'package:att_school/core/utils/helper/backend_message_helper.dart';
import 'package:att_school/features/admin/class/models/class_model.dart';
import 'package:att_school/features/admin/class/read/data/read_class_service.dart';
import 'package:att_school/features/school/provider/school_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ReadClassDetailProvider extends ChangeNotifier {
  final ReadClassService service;
  final SchoolProvider provider;
  ClassModel? _class;
  bool _isLoading = false;
  String _error = '';
  String? _id;

  ReadClassDetailProvider(this.service, this.provider);

  ClassModel? get class_ => _class;

  bool get isLoading => _isLoading;

  String get error => _error;

  Future<BackendMessageHelper> fetchById(String id) async {
    _id = id;
    _error = '';
    _class = null;
    _isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> data = {};
      final response = await service.readClassDetail(id);
      final school = await provider.getSchoolName();

      data = response.data['data'];
      data['school'] = school;


      _class = ClassModel.fromJson(data);

      return BackendMessageHelper(true, data: _class);
    } on DioException catch (e) {
      if (e.response?.statusCode != null) {
        String message = e.response?.data['message'];
        message = BackendFormatter.isNotFound(message);

        _error = "${e.response?.statusCode} - $message";
      } else {
        _error = e.message.toString();
      }

      debugPrint(_error);

      return BackendMessageHelper(false, message: _error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() => _error = '';

  Future<void> reload() => fetchById(_id!);
}
