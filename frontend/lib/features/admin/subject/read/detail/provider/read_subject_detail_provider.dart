import 'package:att_school/core/utils/helper/backend_message_helper.dart';
import 'package:att_school/features/admin/subject/models/subject_model.dart';
import 'package:att_school/features/admin/subject/read/data/read_subject_service.dart';
import 'package:att_school/features/school/provider/school_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ReadSubjectDetailProvider extends ChangeNotifier {
  final ReadSubjectService service;
  final SchoolProvider provider;
  SubjectModel? _subject;
  bool _isLoading = false;
  String _error = '';
  String? _id ;

  ReadSubjectDetailProvider(this.service, this.provider);

  SubjectModel? get subject => _subject;

  bool get isLoading => _isLoading;

  String get error => _error;

  Future<BackendMessageHelper> fetchById(String id) async {
    _id = id;
    _error = '';
    _subject = null;
    _isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> data = {};
      final response = await service.readSubjectDetail(id);
      final school = await provider.getSchoolName();

      if (response.data != null) {
        data = response.data['data'];
        data['school'] = school;

        _subject = SubjectModel.fromJson(data);
      }

      final message = response.data['message'].toString();

      return BackendMessageHelper(true, message: message, data: _subject);
    } on DioException catch (e) {
      debugPrint(e.toString());
      _error = "${e.response?.statusCode} - ${e.response?.statusMessage}";

      return BackendMessageHelper(false, message: _error);
    } catch (e) {
      debugPrint(e.toString());
      _error = e.toString();

      return BackendMessageHelper(false, message: _error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reload() => fetchById(_id!);
}
