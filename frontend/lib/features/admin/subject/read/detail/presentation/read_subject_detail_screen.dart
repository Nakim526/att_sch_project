import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/features/admin/subject/read/detail/provider/read_subject_detail_provider.dart';
import 'package:att_school/features/admin/subject/update/presentation/update_subject_screen.dart';
import 'package:att_school/shared/styles/app_button_style.dart';
import 'package:att_school/shared/styles/app_text_style.dart';
import 'package:att_school/shared/widgets/elements/app_text.dart';
import 'package:att_school/shared/widgets/elements/button/app_button.dart';
import 'package:att_school/shared/widgets/layout/app_loading.dart';
import 'package:att_school/shared/widgets/layout/app_screen.dart';
import 'package:att_school/shared/widgets/layout/app_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReadSubjectDetailScreen extends StatelessWidget {
  const ReadSubjectDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ReadSubjectDetailProvider>(
      builder: (context, provider, _) {
        return Stack(
          children: [
            AppScreen(
              appBar: AppBar(title: const Text('Read Subject Detail')),
              children: [
                AppText("Subject Detail", variant: AppTextVariant.h2),
                AppButton(
                  "Update",
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return UpdateSubjectScreen(provider.subject?.id! ?? '');
                        },
                      ),
                    );

                    provider.reload();
                  },
                  variant: AppButtonVariant.primary,
                ),
                if (provider.subject != null)
                  AppSection(
                    spacing: AppSize.xSmall,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: AppText(
                              "Mata Pelajaran",
                              variant: AppTextVariant.body,
                            ),
                          ),
                          AppText(" : ", variant: AppTextVariant.body),
                          Expanded(
                            flex: 3,
                            child: AppText(
                              provider.subject!.name,
                              variant: AppTextVariant.body,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: AppText(
                              "Sekolah",
                              variant: AppTextVariant.body,
                            ),
                          ),
                          AppText(" : ", variant: AppTextVariant.body),
                          Expanded(
                            flex: 3,
                            child: AppText(
                              provider.subject!.school!,
                              variant: AppTextVariant.body,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
            if (provider.isLoading || provider.subject == null) AppLoading(),
          ],
        );
      },
    );
  }
}
