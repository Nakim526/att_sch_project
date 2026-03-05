import 'package:att_school/core/utils/extensions/string_extension.dart';
import 'package:att_school/core/utils/formatter/date_formatter.dart';

class SemesterModel {
  final String? id;
  final String name;
  final String academicYearId;
  final String? academicYearName;
  final String? school;
  final String? schoolId;
  final DateTime startDate;
  final DateTime endDate;
  final bool? isActive;

  SemesterModel({
    this.id,
    required this.name,
    required this.academicYearId,
    this.academicYearName,
    this.school,
    this.schoolId,
    required this.startDate,
    required this.endDate,
    this.isActive,
  });

  static SemesterModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    
    return SemesterModel(
      id: json['id'],
      name: json['name'].toString().capitalizeEachWord(),
      academicYearId: json['academicYear']['id'].toString(),
      academicYearName: json['academicYear']['name'],
      school: json['school'],
      schoolId: json['schoolId'],
      startDate: DateFormatter.fromJson(json['startDate']),
      endDate: DateFormatter.fromJson(json['endDate']),
      isActive: json['isActive'],
    );
  }

  static SemesterModel? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;

    return SemesterModel(
      id: map['id'],
      name: map['name'].toString().capitalizeEachWord(),
      academicYearId: map['academicYearId'],
      startDate: DateTime.tryParse(map['startDate']) ?? DateTime.now(),
      endDate: DateTime.tryParse(map['endDate']) ?? DateTime.now(),
      isActive: map['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'academicYearId': academicYearId,
      'name': name.toUpperCase(),
      'startDate': DateFormatter.toJson(startDate),
      'endDate': DateFormatter.toJson(endDate),
      'isActive': isActive,
    };
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'academicYearId': academicYearId,
      'academicYearName': academicYearName,
      'school': school,
      'schoolId': schoolId,
      'startDate': DateFormatter.toView(startDate),
      'endDate': DateFormatter.toView(endDate),
    };
  }
}
