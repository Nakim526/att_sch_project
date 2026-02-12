import 'package:att_school/app/app.dart';
import 'package:att_school/core/network/dio_client.dart';
import 'package:att_school/core/network/dio_interceptors.dart';
import 'package:att_school/features/auth/data/auth_service.dart';
import 'package:att_school/features/auth/provider/auth_provider.dart';
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

        /// 🔹 Providers (State)
        /// 🔸 Auth
        ChangeNotifierProvider<AuthProvider>(
          create: (context) {
            return AuthProvider(context.read<AuthService>());
          },
        ),
      ],
      child: const MainApp(),
    ),
  );
}
