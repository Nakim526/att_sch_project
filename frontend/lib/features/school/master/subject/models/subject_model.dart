class SubjectModel {
  final String? id;
  final String name;
  final String? code;
  final String? schoolId;
  final String? school;

  SubjectModel({
    this.id,
    required this.name,
    this.code,
    this.schoolId,
    this.school,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      schoolId: json['schoolId'],
      school: json['school'],
    );
  }

  static SubjectModel? fromMap(Map<String, dynamic>? map) {
    if (map == null) return null;

    return SubjectModel(
      id: map['id'],
      name: map['name'],
      code: map['code'],
      schoolId: map['schoolId'],
      school: map['school'],
    );
  }

  static List<SubjectModel>? fromList(List<Map<String, dynamic>>? list) {
    if (list == null) return null;

    List<SubjectModel> result = [];
    for (final item in list) {
      result.add(SubjectModel.fromMap(item)!);
    }

    return result;
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'name': name, 'code': code};
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id!, 'name': name};
  }
}
