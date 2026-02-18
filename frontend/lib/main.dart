import 'package:att_school/app/app.dart';
import 'package:att_school/core/constant/theme/theme_controller.dart';
import 'package:att_school/core/network/dio_client.dart';
import 'package:att_school/core/network/dio_interceptors.dart';
import 'package:att_school/features/admin/academic-year/create/data/create_academic_year_service.dart';
import 'package:att_school/features/admin/academic-year/create/provider/create_academic_year_provider.dart';
import 'package:att_school/features/admin/academic-year/delete/data/delete_academic_year_service.dart';
import 'package:att_school/features/admin/academic-year/delete/provider/delete_academic_year_provider.dart';
import 'package:att_school/features/admin/academic-year/read/data/read_academic_year_service.dart';
import 'package:att_school/features/admin/academic-year/read/detail/provider/read_academic_year_detail_provider.dart';
import 'package:att_school/features/admin/academic-year/read/list/provider/read_academic_year_list_provider.dart';
import 'package:att_school/features/admin/academic-year/update/data/update_academic_year_service.dart';
import 'package:att_school/features/admin/academic-year/update/provider/update_academic_year_provider.dart';
import 'package:att_school/features/admin/class/create/data/create_class_service.dart';
import 'package:att_school/features/admin/class/create/provider/create_class_provider.dart';
import 'package:att_school/features/admin/class/delete/data/delete_class_service.dart';
import 'package:att_school/features/admin/class/delete/provider/delete_class_provider.dart';
import 'package:att_school/features/admin/class/read/data/read_class_service.dart';
import 'package:att_school/features/admin/class/read/detail/provider/read_class_detail_provider.dart';
import 'package:att_school/features/admin/class/read/list/provider/read_class_list_provider.dart';
import 'package:att_school/features/admin/class/update/data/update_class_service.dart';
import 'package:att_school/features/admin/class/update/provider/update_class_provider.dart';
import 'package:att_school/features/admin/has-access/create/data/create_has_access_service.dart';
import 'package:att_school/features/admin/has-access/create/provider/create_has_acces_provider.dart';
import 'package:att_school/features/admin/has-access/delete/data/delete_has_access_service.dart';
import 'package:att_school/features/admin/has-access/delete/provider/delete_has_access_provider.dart';
import 'package:att_school/features/admin/has-access/read/data/read_has_access_service.dart';
import 'package:att_school/features/admin/has-access/read/detail/provider/read_has_access_detail_provider.dart';
import 'package:att_school/features/admin/has-access/read/list/provider/read_has_access_list_provider.dart';
import 'package:att_school/features/admin/has-access/update/data/update_has_access_service.dart';
import 'package:att_school/features/admin/has-access/update/provider/update_has_access_provider.dart';
import 'package:att_school/features/admin/subject/create/data/create_subject_service.dart';
import 'package:att_school/features/admin/subject/create/provider/create_subject_provider.dart';
import 'package:att_school/features/admin/subject/delete/data/delete_subject_service.dart';
import 'package:att_school/features/admin/subject/delete/provider/delete_subject_provider.dart';
import 'package:att_school/features/admin/subject/read/data/read_subject_service.dart';
import 'package:att_school/features/admin/subject/read/detail/provider/read_subject_detail_provider.dart';
import 'package:att_school/features/admin/subject/read/list/provider/read_subject_list_provider.dart';
import 'package:att_school/features/admin/subject/update/data/update_subject_service.dart';
import 'package:att_school/features/admin/subject/update/provider/update_subject_provider.dart';
import 'package:att_school/features/admin/teacher/create/data/create_teacher_service.dart';
import 'package:att_school/features/admin/teacher/create/provider/create_teacher_provider.dart';
import 'package:att_school/features/admin/teacher/delete/data/delete_teacher_service.dart';
import 'package:att_school/features/admin/teacher/delete/provider/delete_teacher_provider.dart';
import 'package:att_school/features/admin/teacher/read/data/read_teacher_service.dart';
import 'package:att_school/features/admin/teacher/read/detail/provider/read_teacher_detail_provider.dart';
import 'package:att_school/features/admin/teacher/read/list/provider/read_teacher_list_provider.dart';
import 'package:att_school/features/admin/teacher/update/data/update_teacher_service.dart';
import 'package:att_school/features/admin/teacher/update/provider/update_teacher_provider.dart';
import 'package:att_school/features/auth/data/auth_service.dart';
import 'package:att_school/features/auth/provider/auth_provider.dart';
import 'package:att_school/features/school/data/school_service.dart';
import 'package:att_school/features/school/provider/school_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

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

        /// 🔸 School
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

        /// 🔸 Has Access
        Provider<CreateHasAccessService>(
          create: (context) => CreateHasAccessService(context.read<Dio>()),
        ),
        Provider<ReadHasAccessService>(
          create: (context) => ReadHasAccessService(context.read<Dio>()),
        ),
        Provider<UpdateHasAccessService>(
          create: (context) => UpdateHasAccessService(context.read<Dio>()),
        ),
        Provider<DeleteHasAccessService>(
          create: (context) => DeleteHasAccessService(context.read<Dio>()),
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

        /// 🔹 Providers (State)
        /// 🔸 Auth
        ChangeNotifierProvider<AuthProvider>(
          create: (context) {
            return AuthProvider(context.read<AuthService>());
          },
        ),

        /// 🔸 School
        ChangeNotifierProvider<SchoolProvider>(
          create: (context) {
            return SchoolProvider(context.read<SchoolService>());
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
              context.read<SchoolProvider>(),
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

        /// 🔸 Has Access
        ChangeNotifierProvider<ReadHasAccessListProvider>(
          create: (context) {
            return ReadHasAccessListProvider(
              context.read<ReadHasAccessService>(),
            );
          },
        ),
        ChangeNotifierProvider<CreateHasAccessProvider>(
          create: (context) {
            return CreateHasAccessProvider(
              context.read<CreateHasAccessService>(),
            );
          },
        ),
        ChangeNotifierProvider<ReadHasAccessDetailProvider>(
          create: (context) {
            return ReadHasAccessDetailProvider(
              context.read<ReadHasAccessService>(),
              context.read<SchoolProvider>(),
            );
          },
        ),
        ChangeNotifierProvider<UpdateHasAccessProvider>(
          create: (context) {
            return UpdateHasAccessProvider(
              context.read<UpdateHasAccessService>(),
            );
          },
        ),
        ChangeNotifierProvider<DeleteHasAccessProvider>(
          create: (context) {
            return DeleteHasAccessProvider(
              context.read<DeleteHasAccessService>(),
            );
          },
        ),

        /// 🔸 Teachers
        ChangeNotifierProvider<ReadTeacherListProvider>(
          create: (context) {
            return ReadTeacherListProvider(
              context.read<ReadTeacherService>(),
              context.read<ReadHasAccessListProvider>(),
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
            );
          },
        ),
        ChangeNotifierProvider<UpdateTeacherProvider>(
          create: (context) {
            return UpdateTeacherProvider(
              context.read<UpdateTeacherService>(),
            );
          },
        ),
        ChangeNotifierProvider<DeleteTeacherProvider>(
          create: (context) {
            return DeleteTeacherProvider(
              context.read<DeleteTeacherService>(),
            );
          },
        ),

        /// 🔸 AcademicYears
        ChangeNotifierProvider<ReadAcademicYearListProvider>(
          create: (context) {
            return ReadAcademicYearListProvider(context.read<ReadAcademicYearService>());
          },
        ),
        ChangeNotifierProvider<CreateAcademicYearProvider>(
          create: (context) {
            return CreateAcademicYearProvider(context.read<CreateAcademicYearService>());
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
            return UpdateAcademicYearProvider(context.read<UpdateAcademicYearService>());
          },
        ),
        ChangeNotifierProvider<DeleteAcademicYearProvider>(
          create: (context) {
            return DeleteAcademicYearProvider(context.read<DeleteAcademicYearService>());
          },
        ),

        ChangeNotifierProvider(create: (_) => ThemeController()),
      ],
      child: const MainApp(),
    ),
  );
}
