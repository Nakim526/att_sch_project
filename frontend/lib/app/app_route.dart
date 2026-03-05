import 'package:att_school/features/admin/school/create/presentation/create_school_screen.dart';
import 'package:att_school/features/admin/school/read/list/presentation/read_school_list_screen.dart';
import 'package:att_school/features/school/master/academic-year/create/presentation/create_academic_year_screen.dart';
import 'package:att_school/features/school/master/academic-year/read/list/presentation/read_academic_year_list_screen.dart';
import 'package:att_school/features/school/master/class/create/presentation/create_class_screen.dart';
import 'package:att_school/features/school/master/class/read/list/presentation/read_class_list_screen.dart';
import 'package:att_school/features/school/master/user/create/presentation/create_user_screen.dart';
import 'package:att_school/features/school/master/user/read/list/presentation/read_user_list_screen.dart';
import 'package:att_school/features/school/master/semester/create/presentation/create_semester_screen.dart';
import 'package:att_school/features/school/master/semester/read/list/presentation/read_semester_list_screen.dart';
import 'package:att_school/features/school/master/student/create/presentation/create_student_screen.dart';
import 'package:att_school/features/school/master/student/read/list/presentation/read_student_list_screen.dart';
import 'package:att_school/features/school/master/subject/create/presentation/create_subject_screen.dart';
import 'package:att_school/features/school/master/subject/read/list/presentation/read_subject_list_screen.dart';
import 'package:att_school/features/school/master/teacher/create/presentation/create_teacher_screen.dart';
import 'package:att_school/features/school/master/teacher/read/list/presentation/read_teacher_list_screen.dart';
import 'package:att_school/features/auth/presentation/auth_login_screen.dart';
import 'package:att_school/features/dashboard_screen.dart';
import 'package:att_school/features/school/teacher/my-class/list/presentation/read_my_class_list_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  const AppRoutes._();

  static Map<String, WidgetBuilder> of(BuildContext context) {
    return <String, WidgetBuilder>{
      '/login': (context) => const AuthLoginScreen(),
      '/dashboard': (context) => const DashboardScreen(),
      '/schools': (context) => const ReadSchoolListScreen(),
      '/schools/create': (context) => const CreateSchoolScreen(),
      '/users': (context) => const ReadUserListScreen(),
      '/users/create': (context) => const CreateUserScreen(),
      '/teachers': (context) => const ReadTeacherListScreen(),
      '/teachers/create': (context) => const CreateTeacherScreen(),
      '/academic-years': (context) => const ReadAcademicYearListScreen(),
      '/academic-years/create': (context) => const CreateAcademicYearScreen(),
      '/semesters': (context) => const ReadSemesterListScreen(),
      '/semesters/create': (context) => const CreateSemesterScreen(),
      '/classes': (context) => const ReadClassListScreen(),
      '/classes/me': (context) => const ReadMyClassListScreen(),
      '/classes/create': (context) => const CreateClassScreen(),
      '/subjects': (context) => const ReadSubjectListScreen(),
      '/subjects/create': (context) => const CreateSubjectScreen(),
      '/students': (context) => const ReadStudentListScreen(),
      '/students/create': (context) => const CreateStudentScreen(),
    };
  }
}
