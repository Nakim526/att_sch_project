import 'package:att_school/features/school/master/academic-year/models/academic_year_model.dart';
import 'package:att_school/features/school/master/class/models/class_model.dart';
import 'package:att_school/features/school/master/semester/models/semester_model.dart';

class StudentModel {
  final String? id;
  final String name;
  final String nis;
  final String? nisn;
  final String? gender;
  final String? phone;
  final String? address;
  final bool? isActive;
  final String? school;
  final String? schoolId;
  final ClassModel? class_;
  final SemesterModel? semester;
  final AcademicYearModel? academicYear;

  StudentModel({
    this.id,
    required this.name,
    required this.nis,
    this.nisn,
    this.gender,
    this.phone,
    this.address,
    this.isActive,
    this.school,
    this.schoolId,
    this.class_,
    this.semester,
    this.academicYear,
  });

  static StudentModel fromJson(Map<String, dynamic> json) {
    if (json['gender'] != null) {
      json['gender'] = json['gender'] == 'MALE' ? 'Laki-laki' : 'Perempuan';
    }

    return StudentModel(
      id: json['id'],
      name: json['name'],
      nis: json['nis'],
      nisn: json['nisn'],
      gender: json['gender'],
      phone: json['phone'],
      address: json['address'],
      isActive: json['isActive'],
      school: json['school'],
      schoolId: json['schoolId'],
      class_: json['class'],
      semester: json['semester'],
      academicYear: json['academicYear'],
    );
  }

  String? get _genderValue {
    if (gender == null) return null;

    return gender!.toLowerCase() == 'laki-laki' ? 'MALE' : 'FEMALE';
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'nis': nis,
      'nisn': nisn,
      'gender': _genderValue,
      'phone': phone,
      'address': address,
      'isActive': isActive,
      'classId': class_?.id,
      'semesterId': semester?.id,
    };
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'nis': nis,
      'nisn': nisn,
      'gender': gender,
      'phone': phone,
      'address': address,
      'isActive': isActive,
      'school': school,
      'schoolId': schoolId,
      'class': class_,
      'semester': semester,
      'academicYear': academicYear,
    };
  }
}
