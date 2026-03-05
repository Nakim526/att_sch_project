import 'package:att_school/core/utils/formatter/date_formatter.dart';

class AcademicYearModel {
  final String? id;
  final String name;
  final String? schoolId;
  final String? school;
  final DateTime startDate;
  final DateTime endDate;
  final bool? isActive;

  AcademicYearModel({
    this.id,
    required this.name,
    this.schoolId,
    this.school,
    required this.startDate,
    required this.endDate,
    this.isActive,
  });

  static AcademicYearModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    
    return AcademicYearModel(
      id: json['id'],
      name: json['name'],
      school: json['school'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      isActive: json['isActive'],
    );
  }

  static AcademicYearModel? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;

    return AcademicYearModel(
      id: map['id'],
      name: map['name'],
      startDate: DateTime.tryParse(map['startDate']) ?? DateTime.now(),
      endDate: DateTime.tryParse(map['endDate']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'startDate': DateFormatter.toJson(startDate),
      'endDate': DateFormatter.toJson(endDate),
      'isActive': isActive,
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
      'isActive': isActive,
    };
  }
}
