import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/features/school/master/semester/read/detail/provider/read_semester_active_provider.dart';
import 'package:att_school/features/school/master/student/read/detail/provider/read_student_detail_provider.dart';
import 'package:att_school/features/school/master/student/update/presentation/update_student_screen.dart';
import 'package:att_school/shared/styles/app_button_style.dart';
import 'package:att_school/shared/styles/app_text_style.dart';
import 'package:att_school/shared/widgets/elements/field/app_field.dart';
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
    final semester = context.watch<ReadSemesterActiveProvider>();

    return Consumer<ReadStudentDetailProvider>(
      builder: (context, provider, _) {
        final detail = provider.data;

        // 🔥 SIDE-EFFECT: dialog
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (semester.error.isNotEmpty) {
            AppDialog.show(context, title: 'Error', message: semester.error);

            // penting: reset error
            semester.clearError();
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
                          return UpdateStudentScreen(provider.data?.id! ?? '');
                        },
                      ),
                    );

                    await provider.reload();
                  },
                  variant: AppButtonVariant.primary,
                ),
                if (detail != null && semester.data != null)
                  Column(
                    spacing: AppSize.medium,
                    children: [
                      AppSection(
                        title: 'Data Siswa',
                        children: [
                          AppField('NIS', value: detail.nis),
                          AppField('NISN', value: detail.nisn),
                          AppField('Name', value: detail.name),
                          AppField('Jenis Kelamin', value: detail.gender),
                          AppField('Nomor Telepon', value: detail.phone),
                          AppField('Alamat', value: detail.address),
                        ],
                      ),
                      AppSection(
                        title: 'Detail',
                        children: [
                          AppField('Class', value: detail.class_?.name),
                          AppField('Semester', value: detail.semester?.name),
                          AppField(
                            'Tahun Ajaran',
                            value: detail.academicYear?.name,
                          ),
                          AppField('Sekolah', value: detail.school),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
            if (provider.isLoading || detail == null || semester.data == null)
              AppLoading(),
          ],
        );
      },
    );
  }
}
