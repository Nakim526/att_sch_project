import 'package:att_school/core/utils/helper/backend/backend_message_helper.dart';
import 'package:att_school/core/utils/helper/backend/error_exception_helper.dart';
import 'package:att_school/features/school/master/user/models/user_model.dart';
import 'package:att_school/features/school/master/user/read/data/read_user_service.dart';
import 'package:att_school/features/school/public/provider/school_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ReadUserDetailProvider extends ChangeNotifier {
  final CancelToken _cancelToken = CancelToken();
  final ReadUserService service;
  final SchoolProvider schoolProvider;
  UserModel? _hasAccess;
  bool _isLoading = false;
  bool _disposed = false;
  bool _isReady = false;
  String _error = '';
  String? _id;

  ReadUserDetailProvider(this.service, this.schoolProvider);

  bool get isLoading => _isLoading;

  String get error => _error;

  UserModel? get data => _hasAccess;

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
    _hasAccess = null;
    _isLoading = true;
    notifyListeners();

    try {
      final response = await service.readUserDetail(id, _cancelToken);

      _hasAccess = UserModel.fromJson(response.data['data']);

      return BackendMessageHelper(true, data: _hasAccess);
    } on DioException catch (e) {
      _error = ErrorExceptionHelper(e, 'Hak Akses').toString();

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
