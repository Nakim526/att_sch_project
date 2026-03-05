import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/core/utils/extensions/theme_extension.dart';
import 'package:att_school/features/school/data/teaching-assignment/data/teaching_assignment_model.dart';
import 'package:att_school/features/school/master/class/read/detail/presentation/read_class_detail_page.dart';
import 'package:att_school/shared/styles/app_button_style.dart';
import 'package:att_school/shared/widgets/elements/button/app_button.dart';
import 'package:att_school/shared/widgets/elements/field/app_field.dart';
import 'package:att_school/shared/widgets/layout/app_section.dart';
import 'package:flutter/material.dart';

class MyClassDetailSection extends StatelessWidget {
  final List<TeachingAssignmentModel> data;

  const MyClassDetailSection(this.data, {super.key});

  Map<String, List<String>> _groupAssignments(
    List<TeachingAssignmentModel> data,
  ) {
    final Map<String, List<String>> result = {};

    for (final item in data) {
      final className = item.class_?.name ?? '-';
      final subjectName = item.subject?.name ?? '-';

      result.putIfAbsent(className, () => []);
      result[className]!.add(subjectName);
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _groupAssignments(data);
    return AppSection(
      title: 'Daftar Kelas',
      children: [
        ...grouped.entries.map((entry) {
          final className = entry.key;
          final subjects = entry.value;
          final class_ = data.firstWhere((e) => e.class_?.name == className);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSize.normal,
            children: [
              AppField('Kelas', value: className),
              AppField('Mata Pelajaran', values: subjects),
              AppButton(
                'Lihat Kelas',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) {
                        return ReadClassDetailPage(
                          class_.classId,
                          teacherId: data.first.teacherId,
                        );
                      },
                    ),
                  );
                },
                variant: AppButtonVariant.link,
              ),
              if (grouped.keys.toList().indexOf(className) < grouped.length - 1)
                Divider(color: context.outline, height: AppSize.xSmall),
            ],
          );
        }),
      ],
    );
  }
}
