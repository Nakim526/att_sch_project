import 'package:att_school/app/app_route.dart';
import 'package:flutter/material.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Att School',
      routes: AppRoutes.routes(context),
      initialRoute: '/login',
    );
  }
}
