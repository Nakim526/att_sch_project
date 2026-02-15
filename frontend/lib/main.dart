import 'package:att_school/app/app.dart';
import 'package:att_school/core/constant/theme/theme_controller.dart';
import 'package:att_school/core/network/dio_client.dart';
import 'package:att_school/core/network/dio_interceptors.dart';
import 'package:att_school/features/admin/class/create/data/create_class_service.dart';
import 'package:att_school/features/admin/class/create/provider/create_class_provider.dart';
import 'package:att_school/features/admin/class/delete/data/delete_class_service.dart';
import 'package:att_school/features/admin/class/delete/provider/delete_class_provider.dart';
import 'package:att_school/features/admin/class/read/data/read_class_service.dart';
import 'package:att_school/features/admin/class/read/detail/provider/read_class_detail_provider.dart';
import 'package:att_school/features/admin/class/read/list/provider/read_class_list_provider.dart';
import 'package:att_school/features/admin/class/update/data/update_class_service.dart';
import 'package:att_school/features/admin/class/update/provider/update_class_provider.dart';
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

        ChangeNotifierProvider(create: (_) => ThemeController()),
      ],
      child: const MainApp(),
    ),
  );
}
