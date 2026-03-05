class AppItems {
  const AppItems._();

  static List<Map<String, dynamic>> roles = [
    {'id': 'guru', 'name': 'GURU'},
    {'id': 'operator', 'name': 'OPERATOR'},
  ];

  static const Map<String, dynamic> admin = {'id': 'admin', 'name': 'ADMIN'};

  static const Map<String, dynamic> kepsek = {'id': 'kepsek', 'name': 'KEPSEK'};

  static const List status = [null, 'AKTIF', 'TIDAK AKTIF'];

  static const Map<String, int?> gradesMap = {
    '': null,
    'I': 1,
    'II': 2,
    'III': 3,
    'IV': 4,
    'V': 5,
    'VI': 6,
    'VII': 7,
    'VIII': 8,
    'IX': 9,
    'X': 10,
    'XI': 11,
    'XII': 12,
  };

  static const List semester = [null, 'GANJIL', 'GENAP'];

  static const List genders = [null, 'LAKI-LAKI', 'PEREMPUAN'];

  static const List<Map<String, dynamic>> days = [
    {'id': 'senin', 'name': 'SENIN'},
    {'id': 'selasa', 'name': 'SELASA'},
    {'id': 'rabu', 'name': 'RABU'},
    {'id': 'kamis', 'name': 'KAMIS'},
    {'id': 'jum\'at', 'name': 'JUM\'AT'},
    {'id': 'sabtu', 'name': 'SABTU'},
  ];

  static const Map<String, dynamic> dayOfWeek = {
    'SENIN': 'MONDAY',
    'SELASA': 'TUESDAY',
    'RABU': 'WEDNESDAY',
    'KAMIS': 'THURSDAY',
    'JUM\'AT': 'FRIDAY',
    'SABTU': 'SATURDAY',
  };
}
