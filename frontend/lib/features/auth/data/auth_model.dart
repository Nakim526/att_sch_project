class AuthModel {
  final String schoolName;

  AuthModel({required this.schoolName});

  @override
  String toString() => schoolName;

  Map<String, dynamic> toJson() => {'schoolName': schoolName};
}
