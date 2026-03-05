import 'package:att_school/core/utils/helper/backend/error_exception_helper.dart';
import 'package:att_school/features/school/master/user/models/user_model.dart';
import 'package:att_school/features/school/master/user/read/data/read_user_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ReadUserListProvider extends ChangeNotifier {
  final CancelToken _cancelToken = CancelToken();
  final ReadUserService service;
  List<Map<String, dynamic>> _user = [];
  List<String> _userEmails = [];
  bool _isLoading = false;
  bool _disposed = false;
  String _error = '';

  ReadUserListProvider(this.service) {
    _fetch();
  }

  List<Map<String, dynamic>> get data => _user;

  bool get isLoading => _isLoading;

  String get error => _error;

  List<String> get userEmails => _userEmails;

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

  Future<void> _fetch() async {
    _isLoading = true;
    notifyListeners();

    try {
      List<Map<String, dynamic>> result = [];
      List<String> emails = [];
      final response = await service.readUserList(_cancelToken);

      for (final item in response.data['data']) {
        final data = UserModel.fromJson(item);
        emails.add(data.email);
        result.add(data.toMap());
      }

      _user = result;
      _userEmails = emails;
    } on DioException catch (e) {
      _error = ErrorExceptionHelper(e, 'Hak Akses').toString();

      debugPrint(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() => _error = '';

  Future<void> reload() => _fetch();

  Future<void> search(String query) async {
    await _fetch();
    _isLoading = true;
    notifyListeners();
    _user =
        _user.where((e) {
          return e['name'].toString().toLowerCase().contains(
            query.toLowerCase(),
          );
        }).toList();
    _isLoading = false;
    notifyListeners();
  }
}
