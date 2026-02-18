import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/core/constant/size/app_spacing.dart';
import 'package:flutter/material.dart';

class AppScreen extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  const AppScreen({
    super.key,
    required this.children,
    this.appBar,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: ListView(
        padding: AppSpacing.medium,
        children: [
          SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: mainAxisAlignment,
              crossAxisAlignment: crossAxisAlignment,
              spacing: AppSize.large,
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}
