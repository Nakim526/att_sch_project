import 'package:att_school/core/utils/extensions/theme_extension.dart';
import 'package:flutter/material.dart';

class AppLoading extends StatelessWidget {
  const AppLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black45,
      child: Center(child: CircularProgressIndicator(color: context.primary)),
    );
  }
}
