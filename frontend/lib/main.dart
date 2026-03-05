import 'package:att_school/app/app.dart';
import 'package:att_school/core/constant/theme/theme_controller.dart';
import 'package:att_school/core/network/dio_client.dart';
import 'package:att_school/core/network/dio_interceptors.dart';
import 'package:att_school/core/utils/helper/provider/provider_helper.dart';
import 'package:att_school/features/admin/school/create/data/create_school_service.dart';
import 'package:att_school/features/admin/school/create/provider/create_school_provider.dart';
import 'package:att_school/features/admin/school/delete/data/delete_school_service.dart';
import 'package:att_school/features/admin/school/delete/provider/delete_school_provider.dart';
import 'package:att_school/features/admin/school/read/data/read_school_service.dart';
import 'package:att_school/features/admin/school/read/detail/provider/read_school_detail_provider.dart';
import 'package:att_school/features/admin/school/read/list/provider/read_school_list_provider.dart';
import 'package:att_school/features/admin/school/update/data/update_school_service.dart';
import 'package:att_school/features/admin/school/update/provider/update_school_provider.dart';
import 'package:att_school/features/auth/roles/provider/roles_provider.dart';
import 'package:att_school/features/school/master/academic-year/create/data/create_academic_year_service.dart';
import 'package:att_school/features/school/master/academic-year/create/provider/create_academic_year_provider.dart';
import 'package:att_school/features/school/master/academic-year/delete/data/delete_academic_year_service.dart';
import 'package:att_school/features/school/master/academic-year/delete/provider/delete_academic_year_provider.dart';
import 'package:att_school/features/school/master/academic-year/read/data/read_academic_year_service.dart';
import 'package:att_school/features/school/master/academic-year/read/detail/provider/read_academic_year_detail_provider.dart';
import 'package:att_school/features/school/master/academic-year/read/list/provider/read_academic_year_list_provider.dart';
import 'package:att_school/features/school/master/academic-year/update/data/update_academic_year_service.dart';
import 'package:att_school/features/school/master/academic-year/update/provider/update_academic_year_provider.dart';
import 'package:att_school/features/school/master/class/create/data/create_class_service.dart';
import 'package:att_school/features/school/master/class/create/provider/create_class_provider.dart';
import 'package:att_school/features/school/master/class/delete/data/delete_class_service.dart';
import 'package:att_school/features/school/master/class/delete/provider/delete_class_provider.dart';
import 'package:att_school/features/school/master/class/read/data/read_class_service.dart';
import 'package:att_school/features/school/master/class/read/detail/provider/read_class_detail_provider.dart';
import 'package:att_school/features/school/master/class/read/list/provider/read_class_list_provider.dart';
import 'package:att_school/features/school/master/class/update/data/update_class_service.dart';
import 'package:att_school/features/school/master/class/update/provider/update_class_provider.dart';
import 'package:att_school/features/school/master/semester/read/detail/provider/read_semester_active_provider.dart';
import 'package:att_school/features/school/master/user/create/data/create_user_service.dart';
import 'package:att_school/features/school/master/user/create/provider/create_user_provider.dart';
import 'package:att_school/features/school/master/user/delete/data/delete_user_service.dart';
import 'package:att_school/features/school/master/user/delete/provider/delete_user_provider.dart';
import 'package:att_school/features/school/master/user/read/data/read_user_service.dart';
import 'package:att_school/features/school/master/user/read/detail/provider/read_user_detail_provider.dart';
import 'package:att_school/features/school/master/user/read/list/provider/read_user_list_provider.dart';
import 'package:att_school/features/school/master/user/update/data/update_user_service.dart';
import 'package:att_school/features/school/master/user/update/provider/update_user_provider.dart';
import 'package:att_school/features/school/master/semester/create/data/create_semester_service.dart';
import 'package:att_school/features/school/master/semester/create/provider/create_semester_provider.dart';
import 'package:att_school/features/school/master/semester/delete/data/delete_semester_service.dart';
import 'package:att_school/features/school/master/semester/delete/provider/delete_semester_provider.dart';
import 'package:att_school/features/school/master/semester/read/data/read_semester_service.dart';
import 'package:att_school/features/school/master/semester/read/detail/provider/read_semester_detail_provider.dart';
import 'package:att_school/features/school/master/semester/read/list/provider/read_semester_list_provider.dart';
import 'package:att_school/features/school/master/semester/update/data/update_semester_service.dart';
import 'package:att_school/features/school/master/semester/update/provider/update_semester_provider.dart';
import 'package:att_school/features/school/master/student/create/data/create_student_service.dart';
import 'package:att_school/features/school/master/student/create/provider/create_student_provider.dart';
import 'package:att_school/features/school/master/student/delete/data/delete_student_service.dart';
import 'package:att_school/features/school/master/student/delete/provider/delete_student_provider.dart';
import 'package:att_school/features/school/master/student/read/data/read_student_service.dart';
import 'package:att_school/features/school/master/student/read/detail/provider/read_student_detail_provider.dart';
import 'package:att_school/features/school/master/student/read/list/provider/read_student_list_provider.dart';
import 'package:att_school/features/school/master/student/update/data/update_student_service.dart';
import 'package:att_school/features/school/master/student/update/provider/update_student_provider.dart';
import 'package:att_school/features/school/master/subject/create/data/create_subject_service.dart';
import 'package:att_school/features/school/master/subject/create/provider/create_subject_provider.dart';
import 'package:att_school/features/school/master/subject/delete/data/delete_subject_service.dart';
import 'package:att_school/features/school/master/subject/delete/provider/delete_subject_provider.dart';
import 'package:att_school/features/school/master/subject/read/data/read_subject_service.dart';
import 'package:att_school/features/school/master/subject/read/detail/provider/read_subject_detail_provider.dart';
import 'package:att_school/features/school/master/subject/read/list/provider/read_subject_list_provider.dart';
import 'package:att_school/features/school/master/subject/update/data/update_subject_service.dart';
import 'package:att_school/features/school/master/subject/update/provider/update_subject_provider.dart';
import 'package:att_school/features/school/master/teacher/create/data/create_teacher_service.dart';
import 'package:att_school/features/school/master/teacher/create/provider/create_teacher_provider.dart';
import 'package:att_school/features/school/master/teacher/delete/data/delete_teacher_service.dart';
import 'package:att_school/features/school/master/teacher/delete/provider/delete_teacher_provider.dart';
import 'package:att_school/features/school/master/teacher/read/data/read_teacher_service.dart';
import 'package:att_school/features/school/master/teacher/read/detail/provider/read_teacher_detail_provider.dart';
import 'package:att_school/features/school/master/teacher/read/list/provider/read_teacher_list_provider.dart';
import 'package:att_school/features/school/master/teacher/update/data/update_teacher_service.dart';
import 'package:att_school/features/school/master/teacher/update/provider/update_teacher_provider.dart';
import 'package:att_school/features/auth/data/auth_service.dart';
import 'package:att_school/features/auth/provider/auth_provider.dart';
import 'package:att_school/features/school/data/class-teacher/provider/class_teacher_provider.dart';
import 'package:att_school/features/school/public/data/school_service.dart';
import 'package:att_school/features/school/public/provider/school_provider.dart';
import 'package:att_school/features/school/data/student-enrollment/provider/student_enrollment_provider.dart';
import 'package:att_school/features/school/data/teaching-assignment/provider/teaching_assignment_provider.dart';
import 'package:att_school/features/school/teacher/my-class/list/provider/read_my_class_list_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  final dio = DioClient.instance;
  setupDioInterceptor(dio);

  runApp(
    MultiProvider(
      providers: [
        /// 🔹 Global Dio
        Provider<Dio>.value(value: dio),

        /// 🔹 Services
        /// 🔸 Auth
        Provider<AuthService>(
          create: (context) => AuthService(context.read<Dio>()),
        ),

        /// 🔸 School (ADMIN)
        Provider<CreateSchoolService>(
          create: (context) => CreateSchoolService(context.read<Dio>()),
        ),
        Provider<ReadSchoolService>(
          create: (context) => ReadSchoolService(context.read<Dio>()),
        ),
        Provider<UpdateSchoolService>(
          create: (context) => UpdateSchoolService(context.read<Dio>()),
        ),
        Provider<DeleteSchoolService>(
          create: (context) => DeleteSchoolService(context.read<Dio>()),
        ),

        /// 🔸 School (PUBLIC)
        Provider<SchoolService>(
          create: (context) => SchoolService(context.read<Dio>()),
        ),

        /// 🔸 Classes
        Provider<CreateClassService>(
          create: (context) => CreateClassService(context.read<Dio>()),
        ),
        Provider<ReadClassService>(
          create: (context) => ReadClassService(context.read<Dio>()),
        ),
        Provider<UpdateClassService>(
          create: (context) => UpdateClassService(context.read<Dio>()),
        ),
        Provider<DeleteClassService>(
          create: (context) => DeleteClassService(context.read<Dio>()),
        ),

        /// 🔸 Subjects
        Provider<CreateSubjectService>(
          create: (context) => CreateSubjectService(context.read<Dio>()),
        ),
        Provider<ReadSubjectService>(
          create: (context) => ReadSubjectService(context.read<Dio>()),
        ),
        Provider<UpdateSubjectService>(
          create: (context) => UpdateSubjectService(context.read<Dio>()),
        ),
        Provider<DeleteSubjectService>(
          create: (context) => DeleteSubjectService(context.read<Dio>()),
        ),

        /// 🔸 User
        Provider<CreateUserService>(
          create: (context) => CreateUserService(context.read<Dio>()),
        ),
        Provider<ReadUserService>(
          create: (context) => ReadUserService(context.read<Dio>()),
        ),
        Provider<UpdateUserService>(
          create: (context) => UpdateUserService(context.read<Dio>()),
        ),
        Provider<DeleteUserService>(
          create: (context) => DeleteUserService(context.read<Dio>()),
        ),

        /// 🔸 Teachers
        Provider<CreateTeacherService>(
          create: (context) => CreateTeacherService(context.read<Dio>()),
        ),
        Provider<ReadTeacherService>(
          create: (context) => ReadTeacherService(context.read<Dio>()),
        ),
        Provider<UpdateTeacherService>(
          create: (context) => UpdateTeacherService(context.read<Dio>()),
        ),
        Provider<DeleteTeacherService>(
          create: (context) => DeleteTeacherService(context.read<Dio>()),
        ),

        /// 🔸 AcademicYears
        Provider<CreateAcademicYearService>(
          create: (context) => CreateAcademicYearService(context.read<Dio>()),
        ),
        Provider<ReadAcademicYearService>(
          create: (context) => ReadAcademicYearService(context.read<Dio>()),
        ),
        Provider<UpdateAcademicYearService>(
          create: (context) => UpdateAcademicYearService(context.read<Dio>()),
        ),
        Provider<DeleteAcademicYearService>(
          create: (context) => DeleteAcademicYearService(context.read<Dio>()),
        ),

        /// 🔸 Semesters
        Provider<CreateSemesterService>(
          create: (context) => CreateSemesterService(context.read<Dio>()),
        ),
        Provider<ReadSemesterService>(
          create: (context) => ReadSemesterService(context.read<Dio>()),
        ),
        Provider<UpdateSemesterService>(
          create: (context) => UpdateSemesterService(context.read<Dio>()),
        ),
        Provider<DeleteSemesterService>(
          create: (context) => DeleteSemesterService(context.read<Dio>()),
        ),

        /// 🔸 Students
        Provider<CreateStudentService>(
          create: (context) => CreateStudentService(context.read<Dio>()),
        ),
        Provider<ReadStudentService>(
          create: (context) => ReadStudentService(context.read<Dio>()),
        ),
        Provider<UpdateStudentService>(
          create: (context) => UpdateStudentService(context.read<Dio>()),
        ),
        Provider<DeleteStudentService>(
          create: (context) => DeleteStudentService(context.read<Dio>()),
        ),

        /// 🔹 Providers (State)
        /// 🔸 Auth
        ChangeNotifierProvider<AuthProvider>(
          create: (context) {
            return AuthProvider(context.read<AuthService>());
          },
        ),

        /// 🔸 Roles
        ChangeNotifierProvider<RolesProvider>(
          create: (context) {
            return RolesProvider();
          },
        ),

        /// 🔸 School (ADMIN)
        ChangeNotifierProvider<ReadSchoolListProvider>(
          create: (context) {
            return ReadSchoolListProvider(context.read<ReadSchoolService>());
          },
        ),
        ChangeNotifierProvider<CreateSchoolProvider>(
          create: (context) {
            return CreateSchoolProvider(context.read<CreateSchoolService>());
          },
        ),
        ChangeNotifierProvider<ReadSchoolDetailProvider>(
          create: (context) {
            return ReadSchoolDetailProvider(context.read<ReadSchoolService>());
          },
        ),
        ChangeNotifierProvider<UpdateSchoolProvider>(
          create: (context) {
            return UpdateSchoolProvider(context.read<UpdateSchoolService>());
          },
        ),
        ChangeNotifierProvider<DeleteSchoolProvider>(
          create: (context) {
            return DeleteSchoolProvider(context.read<DeleteSchoolService>());
          },
        ),

        /// 🔸 School (PUBLIC)
        ChangeNotifierProvider<SchoolProvider>(
          create: (context) {
            return SchoolProvider(context.read<SchoolService>());
          },
        ),

        /// 🔸 User
        ChangeNotifierProvider<ReadUserListProvider>(
          create: (context) {
            return ReadUserListProvider(context.read<ReadUserService>());
          },
        ),
        ChangeNotifierProvider<CreateUserProvider>(
          create: (context) {
            return CreateUserProvider(context.read<CreateUserService>());
          },
        ),
        ChangeNotifierProvider<ReadUserDetailProvider>(
          create: (context) {
            return ReadUserDetailProvider(
              context.read<ReadUserService>(),
              context.read<SchoolProvider>(),
            );
          },
        ),
        ChangeNotifierProvider<UpdateUserProvider>(
          create: (context) {
            return UpdateUserProvider(context.read<UpdateUserService>());
          },
        ),
        ChangeNotifierProvider<DeleteUserProvider>(
          create: (context) {
            return DeleteUserProvider(context.read<DeleteUserService>());
          },
        ),

        /// 🔸 AcademicYears
        ChangeNotifierProvider<ReadAcademicYearListProvider>(
          create: (context) {
            return ReadAcademicYearListProvider(
              context.read<ReadAcademicYearService>(),
            );
          },
        ),
        ChangeNotifierProvider<CreateAcademicYearProvider>(
          create: (context) {
            return CreateAcademicYearProvider(
              context.read<CreateAcademicYearService>(),
            );
          },
        ),
        ChangeNotifierProvider<ReadAcademicYearDetailProvider>(
          create: (context) {
            return ReadAcademicYearDetailProvider(
              context.read<ReadAcademicYearService>(),
              context.read<SchoolProvider>(),
            );
          },
        ),
        ChangeNotifierProvider<UpdateAcademicYearProvider>(
          create: (context) {
            return UpdateAcademicYearProvider(
              context.read<UpdateAcademicYearService>(),
            );
          },
        ),
        ChangeNotifierProvider<DeleteAcademicYearProvider>(
          create: (context) {
            return DeleteAcademicYearProvider(
              context.read<DeleteAcademicYearService>(),
            );
          },
        ),

        /// 🔸 Semesters
        ChangeNotifierProvider<ReadSemesterListProvider>(
          create: (context) {
            return ReadSemesterListProvider(
              context.read<ReadSemesterService>(),
              context.read<ReadAcademicYearListProvider>(),
            );
          },
        ),
        ChangeNotifierProvider<CreateSemesterProvider>(
          create: (context) {
            return CreateSemesterProvider(
              context.read<CreateSemesterService>(),
            );
          },
        ),
        ChangeNotifierProvider<ReadSemesterDetailProvider>(
          create: (context) {
            return ReadSemesterDetailProvider(
              context.read<ReadSemesterService>(),
              context.read<SchoolProvider>(),
            );
          },
        ),
        ChangeNotifierProvider<UpdateSemesterProvider>(
          create: (context) {
            return UpdateSemesterProvider(
              context.read<UpdateSemesterService>(),
            );
          },
        ),
        ChangeNotifierProvider<DeleteSemesterProvider>(
          create: (context) {
            return DeleteSemesterProvider(
              context.read<DeleteSemesterService>(),
            );
          },
        ),
        ChangeNotifierProvider<ReadSemesterActiveProvider>(
          create: (context) {
            return ReadSemesterActiveProvider(
              context.read<ReadSemesterService>(),
              context.read<SchoolProvider>(),
              context.read<ReadAcademicYearDetailProvider>(),
            );
          },
        ),

        /// 🔸 Subjects
        ChangeNotifierProvider<ReadSubjectListProvider>(
          create: (context) {
            return ReadSubjectListProvider(context.read<ReadSubjectService>());
          },
        ),
        ChangeNotifierProvider<CreateSubjectProvider>(
          create: (context) {
            return CreateSubjectProvider(context.read<CreateSubjectService>());
          },
        ),
        ChangeNotifierProvider<ReadSubjectDetailProvider>(
          create: (context) {
            return ReadSubjectDetailProvider(
              context.read<ReadSubjectService>(),
              context.read<SchoolProvider>(),
            );
          },
        ),
        ChangeNotifierProvider<UpdateSubjectProvider>(
          create: (context) {
            return UpdateSubjectProvider(context.read<UpdateSubjectService>());
          },
        ),
        ChangeNotifierProvider<DeleteSubjectProvider>(
          create: (context) {
            return DeleteSubjectProvider(context.read<DeleteSubjectService>());
          },
        ),

        /// 🔸 Class Teachers
        ChangeNotifierProvider<ClassTeacherProvider>(
          create: (context) {
            return ClassTeacherProvider(context.read<ReadTeacherService>());
          },
        ),

        /// 🔸 Classes
        ChangeNotifierProvider<ReadClassListProvider>(
          create: (context) {
            return ReadClassListProvider(context.read<ReadClassService>());
          },
        ),
        ChangeNotifierProvider<CreateClassProvider>(
          create: (context) {
            return CreateClassProvider(context.read<CreateClassService>());
          },
        ),
        ChangeNotifierProvider<ReadClassDetailProvider>(
          create: (context) {
            return ReadClassDetailProvider(
              context.read<ReadClassService>(),
              context.read<ReadSubjectService>(),
              context.read<SchoolProvider>(),
              context.read<ClassTeacherProvider>(),
            );
          },
        ),
        ChangeNotifierProvider<UpdateClassProvider>(
          create: (context) {
            return UpdateClassProvider(context.read<UpdateClassService>());
          },
        ),
        ChangeNotifierProvider<DeleteClassProvider>(
          create: (context) {
            return DeleteClassProvider(context.read<DeleteClassService>());
          },
        ),

        /// 🔸 My Class (Teachers)
        ChangeNotifierProvider<ReadMyClassListProvider>(
          create: (context) {
            return ReadMyClassListProvider(context.read<ReadClassService>());
          },
        ),

        /// 🔸 TeachingAssignment
        ChangeNotifierProvider<TeachingAssignmentProvider>(
          create: (context) {
            return TeachingAssignmentProvider(
              context.read<ReadSubjectDetailProvider>(),
              context.read<ReadClassDetailProvider>(),
              context.read<ReadSemesterActiveProvider>(),
            );
          },
        ),

        /// 🔸 Teachers
        ChangeNotifierProvider<ReadTeacherListProvider>(
          create: (context) {
            return ReadTeacherListProvider(
              context.read<ReadTeacherService>(),
              context.read<ReadUserListProvider>(),
            );
          },
        ),
        ChangeNotifierProvider<CreateTeacherProvider>(
          create: (context) {
            return CreateTeacherProvider(context.read<CreateTeacherService>());
          },
        ),
        ChangeNotifierProvider<ReadTeacherDetailProvider>(
          create: (context) {
            return ReadTeacherDetailProvider(
              context.read<ReadTeacherService>(),
              context.read<SchoolProvider>(),
              context.read<TeachingAssignmentProvider>(),
            );
          },
        ),
        ChangeNotifierProvider<UpdateTeacherProvider>(
          create: (context) {
            return UpdateTeacherProvider(context.read<UpdateTeacherService>());
          },
        ),
        ChangeNotifierProvider<DeleteTeacherProvider>(
          create: (context) {
            return DeleteTeacherProvider(context.read<DeleteTeacherService>());
          },
        ),

        /// 🔸 StudentEnrollment
        ChangeNotifierProvider<StudentEnrollmentProvider>(
          create: (context) {
            return StudentEnrollmentProvider(
              context.read<ReadClassDetailProvider>(),
              context.read<ReadSemesterActiveProvider>(),
            );
          },
        ),

        // /// 🔸 Students
        ChangeNotifierProvider<ReadStudentListProvider>(
          create: (context) {
            return ReadStudentListProvider(context.read<ReadStudentService>());
          },
        ),
        ChangeNotifierProvider<CreateStudentProvider>(
          create: (context) {
            return CreateStudentProvider(context.read<CreateStudentService>());
          },
        ),
        ChangeNotifierProvider<ReadStudentDetailProvider>(
          create: (context) {
            return ReadStudentDetailProvider(
              context.read<ReadStudentService>(),
              context.read<SchoolProvider>(),
              context.read<StudentEnrollmentProvider>(),
            );
          },
        ),
        ChangeNotifierProvider<UpdateStudentProvider>(
          create: (context) {
            return UpdateStudentProvider(context.read<UpdateStudentService>());
          },
        ),
        ChangeNotifierProvider<DeleteStudentProvider>(
          create: (context) {
            return DeleteStudentProvider(context.read<DeleteStudentService>());
          },
        ),

        ChangeNotifierProvider(create: (_) => ThemeController()),

        ChangeNotifierProvider<ProviderHelper>(
          create: (context) {
            return ProviderHelper(
              context.read<ReadSchoolListProvider>(),
              context.read<ReadUserListProvider>(),
              context.read<ReadAcademicYearListProvider>(),
              context.read<ReadSemesterListProvider>(),
              context.read<ReadTeacherListProvider>(),
              context.read<ReadStudentListProvider>(),
              context.read<ReadSubjectListProvider>(),
              context.read<ReadClassListProvider>(),
              context.read<ReadMyClassListProvider>(),
            );
          },
        ),
      ],
      child: const MainApp(),
    ),
  );
}
