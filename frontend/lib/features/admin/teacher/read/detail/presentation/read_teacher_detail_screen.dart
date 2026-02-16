import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/features/admin/teacher/read/detail/provider/read_teacher_detail_provider.dart';
import 'package:att_school/features/admin/teacher/update/presentation/update_teacher_screen.dart';
import 'package:att_school/shared/styles/app_button_style.dart';
import 'package:att_school/shared/styles/app_text_style.dart';
import 'package:att_school/shared/widgets/elements/app_text.dart';
import 'package:att_school/shared/widgets/elements/button/app_button.dart';
import 'package:att_school/shared/widgets/layout/app_loading.dart';
import 'package:att_school/shared/widgets/layout/app_screen.dart';
import 'package:att_school/shared/widgets/layout/app_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReadTeacherDetailScreen extends StatelessWidget {
  const ReadTeacherDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ReadTeacherDetailProvider>(
      builder: (context, provider, _) {
        final detail = provider.teacher;

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
                if (detail != null)
                  AppSection(
                    spacing: AppSize.xSmall,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: AppText("NIP", variant: AppTextVariant.body),
                          ),
                          AppText(" : ", variant: AppTextVariant.body),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  detail.nip,
                                  variant: AppTextVariant.body,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: AppText(
                              "Nama",
                              variant: AppTextVariant.body,
                            ),
                          ),
                          AppText(" : ", variant: AppTextVariant.body),
                          Expanded(
                            flex: 3,
                            child: AppText(
                              detail.name,
                              variant: AppTextVariant.body,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: AppText(
                              "Email",
                              variant: AppTextVariant.body,
                            ),
                          ),
                          AppText(" : ", variant: AppTextVariant.body),
                          Expanded(
                            flex: 3,
                            child: AppText(
                              detail.email,
                              variant: AppTextVariant.body,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 1,
                            child: AppText(
                              "Sekolah",
                              variant: AppTextVariant.body,
                            ),
                          ),
                          AppText(" : ", variant: AppTextVariant.body),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  detail.school!,
                                  variant: AppTextVariant.body,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
            if (provider.isLoading || provider.teacher == null) AppLoading(),
          ],
        );
      },
    );
  }
}
