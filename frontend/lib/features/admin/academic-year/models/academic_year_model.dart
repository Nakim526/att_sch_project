import 'package:intl/intl.dart';

class AcademicYearModel {
  final String? id;
  final String name;
  final String? schoolId;
  final String? school;
  final DateTime startDate;
  final DateTime endDate;

  AcademicYearModel({
    this.id,
    required this.name,
    this.schoolId,
    this.school,
    required this.startDate,
    required this.endDate,
  });

  static AcademicYearModel? fromJson(Map<String, dynamic> json) {
    return AcademicYearModel(
      id: json['id'],
      name: json['name'],
      schoolId: json['schoolId'],
      school: json['school'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'startDate': startDate.toUtc().toIso8601String(),
      'endDate': endDate.toUtc().toIso8601String(),
    };
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'schoolId': schoolId,
      'school': school,
      'startDate': DateFormat('dd MMM yyyy').format(startDate),
      'endDate': DateFormat('dd MMM yyyy').format(endDate),
    };
  }
}
