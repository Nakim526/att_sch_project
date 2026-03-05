import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/core/constant/size/app_spacing.dart';
import 'package:flutter/material.dart';

class AppScreen extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final List<Widget> children;
  final EdgeInsetsGeometry padding;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final double spacing;

  const AppScreen({
    super.key,
    this.appBar,
    required this.children,
    this.padding = AppSpacing.medium,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.spacing = AppSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: ListView(
        padding: padding,
        children: [
          SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: mainAxisAlignment,
              crossAxisAlignment: crossAxisAlignment,
              spacing: spacing,
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}
