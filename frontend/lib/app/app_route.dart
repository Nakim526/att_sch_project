import 'package:att_school/features/admin/class/create/presentation/create_class_screen.dart';
import 'package:att_school/features/admin/class/read/list/presentation/read_class_list_screen.dart';
import 'package:att_school/features/auth/presentation/auth_login_screen.dart';
import 'package:att_school/features/dashboard_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes(BuildContext context) {
    return <String, WidgetBuilder>{
      '/login': (context) => const AuthLoginScreen(),
      '/dashboard': (context) => const DashboardScreen(),
      '/classes': (context) => const ReadClassListScreen(),
      '/classes/create': (context) => const CreateClassScreen(),
    };
  }
}
