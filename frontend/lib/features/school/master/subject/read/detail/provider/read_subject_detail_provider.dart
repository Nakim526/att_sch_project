import 'package:att_school/core/utils/helper/backend/backend_message_helper.dart';
import 'package:att_school/core/utils/helper/backend/error_exception_helper.dart';
import 'package:att_school/features/school/master/subject/models/subject_model.dart';
import 'package:att_school/features/school/master/subject/read/data/read_subject_service.dart';
import 'package:att_school/features/school/public/provider/school_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ReadSubjectDetailProvider extends ChangeNotifier {
  final CancelToken _cancelToken = CancelToken();
  final ReadSubjectService service;
  final SchoolProvider school;
  SubjectModel? _subject;
  bool _isLoading = false;
  bool _disposed = false;
  bool _isReady = false;
  String _error = '';
  String? _id;

  ReadSubjectDetailProvider(this.service, this.school);

  SubjectModel? get data => _subject;

  bool get isLoading => _isLoading;

  String get error => _error;

  bool get isReady => _isReady;

  set ready(bool value) {
    _isReady = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _cancelToken.cancel('Page disposed');
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  Future<BackendMessageHelper> fetchById(String id) async {
    _id = id;
    _error = '';
    _subject = null;
    _isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> data = {};
      final response = await service.readSubjectDetail(id, _cancelToken);
      await school.getName();

      data = response.data['data'];
      data['school'] = school.name;

      _subject = SubjectModel.fromJson(data);

      return BackendMessageHelper(true, data: _subject);
    } on DioException catch (e) {
      _error = ErrorExceptionHelper(e, 'Mata Pelajaran').toString();

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
