import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/features/auth/roles/provider/roles_provider.dart';
import 'package:att_school/features/school/master/class/models/class_model.dart';
import 'package:att_school/features/school/master/class/read/detail/provider/read_class_detail_provider.dart';
import 'package:att_school/features/school/master/class/update/presentation/update_class_screen.dart';
import 'package:att_school/features/school/master/semester/read/detail/provider/read_semester_active_provider.dart';
import 'package:att_school/features/school/teacher/my_schedule_section.dart';
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

class ReadClassDetailScreen extends StatelessWidget {
  final String? teacherId;

  const ReadClassDetailScreen({super.key, this.teacherId});

  @override
  Widget build(BuildContext context) {
    final isTeacher = context.select((RolesProvider p) => p.isTeacher);
    final semester = context.watch<ReadSemesterActiveProvider>();

    return Consumer<ReadClassDetailProvider>(
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
              appBar: AppBar(title: const Text('Read Class Detail')),
              children: [
                AppText("Class Detail", variant: AppTextVariant.h2),
                if (!isTeacher)
                  AppButton(
                    "Update",
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return UpdateClassScreen(provider.data?.id! ?? '');
                          },
                        ),
                      );

                      provider.reload();
                    },
                    variant: AppButtonVariant.primary,
                  ),
                if (detail != null && semester.data != null)
                  Column(
                    spacing: AppSize.medium,
                    children: [
                      AppSection(
                        title: 'Data Kelas',
                        children: [
                          AppField(
                            'Tingkat Kelas',
                            value: detail.grade.toString(),
                          ),
                          AppField('Nama Kelas', value: detail.name),
                          AppField('Semester', value: semester.data!.name),
                          AppField(
                            'Tahun Ajaran',
                            value: semester.data!.academicYearName,
                          ),
                          AppField('Sekolah', value: detail.school),
                        ],
                      ),

                      if (teacherId != null) ...{MyScheduleSection(detail)},

                      _detailSection(detail),
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

  Widget _detailSection(ClassModel? detail) {
    final teacher = detail?.teacher;
    final enrollments = detail?.enrollments;

    return AppSection(
      title: 'Detail Kelas',
      children: [
        AppField('Wali Kelas', value: teacher?.name),
        AppField('Jumlah Siswa', value: enrollments?.length.toString()),
        AppField('Daftar Siswa', values: [...?enrollments?.map((e) => e.name)]),
      ],
    );
  }
}
