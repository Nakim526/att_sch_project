import 'package:att_school/features/school/data/school_service.dart';
import 'package:flutter/material.dart';

class SchoolProvider extends ChangeNotifier {
  final SchoolService service;

  SchoolProvider(this.service);

  Future<String> getName() async {
    final response = await service.getCurrent();

    return response.data['name'];
  }
}
