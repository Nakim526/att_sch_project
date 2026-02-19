class AppItems {
  const AppItems._();

  static const List<Map<String, String>> roles = [
    {'id': 'admin', 'name': 'ADMIN'},
    {'id': 'operator', 'name': 'OPERATOR'},
    {'id': 'kepsek', 'name': 'KEPSEK'},
    {'id': 'guru', 'name': 'GURU'},
  ];

  static const List grades = [null, 1, 2, 3, 4, 5, 6];

  static const List semesterType = [null, 'GANJIL', 'GENAP'];

  static const List genders = [null, 'LAKI-LAKI', 'PEREMPUAN'];
}
