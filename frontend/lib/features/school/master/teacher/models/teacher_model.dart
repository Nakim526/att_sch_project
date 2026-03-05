import 'package:att_school/features/school/master/academic-year/models/academic_year_model.dart';
import 'package:att_school/features/school/master/class/models/class_model.dart';
import 'package:att_school/features/school/master/semester/models/semester_model.dart';
import 'package:att_school/features/school/master/subject/models/subject_model.dart';
import 'package:att_school/features/school/data/teaching-assignment/data/teaching_assignment_model.dart';

class TeacherModel {
  final String? id;
  final String nip;
  final String name;
  final String email;
  final String? gender;
  final String? phone;
  final String? address;
  final bool? isActive;
  final String? school;
  final List<TeachingAssignmentModel>? assignments;
  final SemesterModel? semester;
  final AcademicYearModel? academicYear;

  TeacherModel({
    this.id,
    required this.nip,
    required this.name,
    required this.email,
    this.gender,
    this.phone,
    this.address,
    this.isActive,
    this.school,
    this.assignments,
    this.semester,
    this.academicYear,
  });

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    if (json['gender'] != null) {
      json['gender'] = json['gender'] == 'MALE' ? 'Laki-laki' : 'Perempuan';
    }

    return TeacherModel(
      id: json['id'],
      nip: json['nip'],
      name: json['name'],
      gender: json['gender'],
      phone: json['phone'],
      address: json['address'],
      email: json['user']['email'],
      isActive: json['isActive'],
      school: json['school'],
      assignments: json['assignments'],
      semester: json['semester'],
      academicYear: json['academicYear'],
    );
  }

  String? get _genderValue {
    if (gender == null) return null;

    return gender!.toLowerCase() == 'laki-laki' ? 'MALE' : 'FEMALE';
  }

  Map<String, dynamic> toJson() => {
    'nip': nip,
    'name': name,
    'email': email,
    'gender': _genderValue,
    'phone': phone,
    'address': address,
    'isActive': isActive,
    'assignments': assignments?.map((e) => e.toJson()).toList(),
  };

  Map<String, dynamic> toMap() => {
    'id': id,
    'nip': nip,
    'name': name,
    'gender': gender,
    'phone': phone,
    'address': address,
    'email': email,
    'school': school,
    'isActive': isActive,
    'semester': semester,
    'academicYear': academicYear,
  };

  List<ClassModel?>? get classes {
    return assignments?.map((e) => e.class_).toList();
  }

  List<SubjectModel?>? get subjects {
    return assignments?.map((e) => e.subject).toList();
  }
}
