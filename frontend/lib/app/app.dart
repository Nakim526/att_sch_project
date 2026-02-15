import 'package:att_school/app/app_route.dart';
import 'package:att_school/core/constant/theme/app_theme.dart';
import 'package:att_school/core/constant/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();

    themeController.loadTheme();

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeController.themeMode,
        title: 'Att School',
        routes: AppRoutes.routes(context),
        initialRoute: '/login',
      ),
    );
  }
}
