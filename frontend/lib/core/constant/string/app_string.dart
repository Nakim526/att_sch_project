class AppString {
  const AppString._();
  
  static const String _clientId =
      '530669528444-imn6up9ibk7tt84dme9ddjgo5jv45ma9.apps.googleusercontent.com';

  static const String _serverClientId =
      '530669528444-ud001l7i8jd8o7nte1c81r3ft9e4de6u.apps.googleusercontent.com';

  static String get clientId => _clientId;

  static String get serverClientId => _serverClientId;

  static const String appName = 'Att School';

  static const String baseUrl = 'http://192.168.1.8:3000/api';

  static const String loginUrl = '$baseUrl/auth/google';

  static const String schoolUrl = '$baseUrl/schools';

  static const String hasAccessUrl = '$baseUrl/has-access';

  static const String teacherUrl = '$baseUrl/teachers';

  static const String academicYearUrl = '$baseUrl/academic-years';

  static const String semesterUrl = '$baseUrl/semesters';

  static const String classUrl = '$baseUrl/classes';

  static const String subjectUrl = '$baseUrl/subjects';
}
