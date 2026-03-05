import 'package:att_school/features/school/public/data/school_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SchoolProvider extends ChangeNotifier {
  final CancelToken _cancelToken = CancelToken();
  final SchoolService service;
  String _name = '';

  SchoolProvider(this.service);

  String get name => _name;

  @override
  void dispose() {
    _cancelToken.cancel('Detail page disposed');
    super.dispose();
  }

  Future<void> getName() async {
    final response = await service.getCurrent(_cancelToken);

    _name = response.data['data']['school']['name'];
  }
}
