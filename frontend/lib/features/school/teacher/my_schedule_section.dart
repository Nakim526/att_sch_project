import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/core/utils/extensions/theme_extension.dart';
import 'package:att_school/features/school/data/teaching-assignment/data/teaching_assignment_model.dart';
import 'package:att_school/features/school/master/class/models/class_model.dart';
import 'package:att_school/shared/widgets/elements/field/app_field.dart';
import 'package:att_school/shared/widgets/layout/app_section.dart';
import 'package:flutter/material.dart';

class MyScheduleSection extends StatelessWidget {
  final ClassModel data;

  const MyScheduleSection(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    if (data.assignments?.isEmpty ?? true) return const SizedBox.shrink();

    return Column(
      spacing: AppSize.medium,
      children: [
        for (final e in data.assignments ?? <TeachingAssignmentModel>[]) ...{
          AppSection(
            title: e.subject?.name,
            children: [
              for (int i = 0; i < (e.schedules?.length ?? 0); i++) ...{
                AppField('Hari', value: e.schedules?[i].day_),
                AppField('Waktu', value: e.schedules?[i].time_),

                if (i < (e.schedules?.length ?? 0) - 1)
                  Divider(color: context.outline, height: AppSize.tiny),
              },
            ],
          ),
        },
      ],
    );
  }
}
