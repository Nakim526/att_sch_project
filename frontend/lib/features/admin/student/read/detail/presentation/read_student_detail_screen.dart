import 'package:att_school/features/admin/student/read/detail/provider/read_student_detail_provider.dart';
import 'package:att_school/features/admin/student/update/presentation/update_student_screen.dart';
import 'package:att_school/shared/styles/app_button_style.dart';
import 'package:att_school/shared/styles/app_text_style.dart';
import 'package:att_school/shared/widgets/elements/app_field.dart';
import 'package:att_school/shared/widgets/elements/app_text.dart';
import 'package:att_school/shared/widgets/elements/button/app_button.dart';
import 'package:att_school/shared/widgets/elements/dialog/app_dialog.dart';
import 'package:att_school/shared/widgets/layout/app_loading.dart';
import 'package:att_school/shared/widgets/layout/app_screen.dart';
import 'package:att_school/shared/widgets/layout/app_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReadStudentDetailScreen extends StatelessWidget {
  const ReadStudentDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ReadStudentDetailProvider>(
      builder: (context, provider, _) {
        final detail = provider.student;

        // 🔥 SIDE-EFFECT: dialog
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (provider.error.isNotEmpty) {
            AppDialog.show(context, title: 'Error', message: provider.error);

            // penting: reset error
            provider.clearError();
          }
        });

        return Stack(
          children: [
            AppScreen(
              appBar: AppBar(title: const Text('Read Student Detail')),
              children: [
                AppText("Student Detail", variant: AppTextVariant.h2),
                AppButton(
                  "Update",
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return UpdateStudentScreen(
                            provider.student?.id! ?? '',
                          );
                        },
                      ),
                    );

                    await provider.reload();
                  },
                  variant: AppButtonVariant.primary,
                ),
                if (detail != null)
                  AppSection(
                    children: [
                      AppField('NIS', value: detail.nis),
                      AppField('NISN', value: detail.nisn),
                      AppField('Name', value: detail.name),
                      AppField('Gender', value: detail.gender),
                      AppField('Phone', value: detail.phone),
                      AppField('Address', value: detail.address),
                      AppField('Sekolah', value: detail.school),
                    ],
                  ),
              ],
            ),
            if (provider.isLoading || detail == null) AppLoading(),
          ],
        );
      },
    );
  }
}
