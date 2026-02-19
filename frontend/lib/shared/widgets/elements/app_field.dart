import 'package:att_school/shared/styles/app_text_style.dart';
import 'package:att_school/shared/widgets/elements/app_text.dart';
import 'package:flutter/material.dart';

class AppField extends StatelessWidget {
  final String field;
  final String? value;
  final List<dynamic>? values;

  const AppField(this.field, {super.key, this.value, this.values});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(field, variant: AppTextVariant.caption),
        if (value != null && value!.isNotEmpty)
          AppText(value!, variant: AppTextVariant.body)
        else if (values != null && values!.isNotEmpty)
          for (final value in values!)
            AppText(value, variant: AppTextVariant.body)
        else
          const AppText('None', variant: AppTextVariant.caption),
      ],
    );
  }
}
