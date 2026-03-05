import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/features/school/data/teaching-assignment/data/teaching_assignment_model.dart';
import 'package:att_school/features/school/master/semester/read/detail/provider/read_semester_active_provider.dart';
import 'package:att_school/features/school/master/teacher/models/teacher_model.dart';
import 'package:att_school/features/school/master/teacher/read/detail/provider/read_teacher_detail_provider.dart';
import 'package:att_school/features/school/master/teacher/update/presentation/update_teacher_screen.dart';
import 'package:att_school/features/school/teacher/my-class/detail/presentation/my_class_detail_section.dart';
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

class ReadTeacherDetailScreen extends StatelessWidget {
  final String id;

  const ReadTeacherDetailScreen(this.id, {super.key});

  @override
  Widget build(BuildContext context) {
    final semester = context.watch<ReadSemesterActiveProvider>();

    return Consumer<ReadTeacherDetailProvider>(
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
              appBar: AppBar(title: const Text('Read Teacher Detail')),
              children: [
                AppText("Teacher Detail", variant: AppTextVariant.h2),
                AppButton(
                  "Update",
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return UpdateTeacherScreen(detail?.id! ?? '');
                        },
                      ),
                    );

                    await provider.reload();
                  },
                  variant: AppButtonVariant.primary,
                ),
                if (detail != null && semester.data != null) ...[
                  AppSection(
                    title: 'Data Guru',
                    children: [
                      AppField('NIP', value: detail.nip),
                      AppField('Nama', value: detail.name),
                      AppField('Email', value: detail.email),
                      AppField('Jenis Kelamin', value: detail.gender),
                      AppField('Nomor Telepon', value: detail.phone),
                      AppField('Alamat', value: detail.address),
                    ],
                  ),
                  _detailSection(context, detail),
                ],
              ],
            ),
            if (provider.isLoading || detail == null || semester.data == null)
              AppLoading(),
          ],
        );
      },
    );
  }

  Widget _detailSection(BuildContext context, TeacherModel data) {
    final assignments = data.assignments ?? <TeachingAssignmentModel>[];

    return Column(
      spacing: AppSize.medium,
      children: [
        if (assignments.isNotEmpty) MyClassDetailSection(assignments),

        AppSection(
          title: 'Detail',
          children: [
            AppField('Semester', value: data.semester?.name),
            AppField('Tahun Ajaran', value: data.academicYear?.name),
            AppField('Sekolah', value: data.school!),
          ],
        ),
      ],
    );
  }
}
