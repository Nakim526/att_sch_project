import 'package:att_school/features/auth/presentation/auth_login_screen.dart';
import 'package:att_school/features/dashboard_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes(BuildContext context) {
    return <String, WidgetBuilder>{
      '/login': (context) => const AuthLoginScreen(),
      '/dashboard': (context) => const DashboardScreen(),
    };
  }
}
