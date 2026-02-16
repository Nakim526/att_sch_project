import 'package:att_school/core/utils/helper/backend_message_helper.dart';
import 'package:att_school/features/admin/has-access/read/data/read_has_access_service.dart';
import 'package:flutter/material.dart';

class ReadHasAccessListProvider extends ChangeNotifier {
  final ReadHasAccessService service;
  List<Map<String, dynamic>> _hasAccess = [];
  bool _isLoading = false;
  String _error = '';

  ReadHasAccessListProvider(this.service) {
    _fetch();
  }

  List<Map<String, dynamic>> get hasAccess => _hasAccess;

  bool get isLoading => _isLoading;

  String get error => _error;

  Future<BackendMessageHelper> _fetch() async {
    _isLoading = true;
    notifyListeners();

    try {
      List<Map<String, dynamic>> hasAccess = [];
      final response = await service.readHasAccessList();

      final result = response.data['data'] as List;

      for (final item in result) {
        hasAccess.add({
          'id': item['id'],
          'isActive': item['isActive'] as bool,
          'name': item['user']['name'],
          'email': item['user']['email'],
          'role': item['user']['roles'][0]['role']['name'],
        });
      }

      _hasAccess = hasAccess;

      return BackendMessageHelper(true);
    } catch (e) {
      _error = e.toString();
      debugPrint(_error);

      return BackendMessageHelper(false, message: _error);
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
    _hasAccess =
        _hasAccess.where((e) {
          return e['name'].toString().toLowerCase().contains(
            query.toLowerCase(),
          );
        }).toList();
    _isLoading = false;
    notifyListeners();
  }
}
