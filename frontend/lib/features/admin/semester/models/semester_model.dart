import 'package:att_school/core/utils/extensions/string_extension.dart';
import 'package:att_school/core/utils/formatter/date_formatter.dart';

class SemesterModel {
  final String? id;
  final String type;
  final String academicYearId;
  final String? academicYear;
  final String? school;
  final String? schoolId;
  final DateTime startDate;
  final DateTime endDate;

  SemesterModel({
    this.id,
    required this.type,
    required this.academicYearId,
    this.academicYear,
    this.school,
    this.schoolId,
    required this.startDate,
    required this.endDate,
  });

  static SemesterModel fromJson(Map<String, dynamic> json) {
    return SemesterModel(
      id: json['id'],
      type: json['type'].toString().capitalizeEachWord(),
      academicYearId: json['academicYear']['id'],
      academicYear: json['academicYear']['name'],
      school: json['school'],
      schoolId: json['schoolId'],
      startDate: DateFormatter.fromJson(json['startDate']),
      endDate: DateFormatter.fromJson(json['endDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'academicYearId': academicYearId,
      'type': type.toUpperCase(),
      'startDate': DateFormatter.toJson(startDate),
      'endDate': DateFormatter.toJson(endDate),
    };
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'type': type,
      'academicYearId': academicYearId,
      'academicYear': academicYear,
      'school': school,
      'schoolId': schoolId,
      'startDate': DateFormatter.toView(startDate),
      'endDate': DateFormatter.toView(endDate),
    };
  }
}
