import 'package:att_school/core/utils/formatter/date_formatter.dart';

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

  factory AcademicYearModel.fromJson(Map<String, dynamic> json) {
    return AcademicYearModel(
      id: json['id'],
      name: json['name'],
      school: json['school'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'startDate': DateFormatter.toJson(startDate),
      'endDate': DateFormatter.toJson(endDate),
    };
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'schoolId': schoolId,
      'school': school,
      'startDate': DateFormatter.toView(startDate),
      'endDate': DateFormatter.toView(endDate),
    };
  }
}
