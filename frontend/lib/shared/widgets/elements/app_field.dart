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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: AppText(field, variant: AppTextVariant.body)),
        AppText(" : ", variant: AppTextVariant.body),
        if (value != null)
          Expanded(
            flex: 3,
            child: AppText(value!, variant: AppTextVariant.body),
          ),
        if (values != null)
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (values!.length > 1)
                  for (final value in values!)
                    AppText(
                      '${values!.indexOf(value) + 1}. $value',
                      variant: AppTextVariant.body,
                    )
                else
                  AppText(values!.first, variant: AppTextVariant.body),
              ],
            ),
          ),
      ],
    );
  }
}
