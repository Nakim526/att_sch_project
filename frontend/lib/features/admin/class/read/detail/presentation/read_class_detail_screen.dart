import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/features/admin/class/read/detail/provider/read_class_detail_provider.dart';
import 'package:att_school/features/admin/class/update/presentation/update_class_screen.dart';
import 'package:att_school/shared/styles/app_button_style.dart';
import 'package:att_school/shared/styles/app_text_style.dart';
import 'package:att_school/shared/widgets/elements/app_text.dart';
import 'package:att_school/shared/widgets/elements/button/app_button.dart';
import 'package:att_school/shared/widgets/layout/app_screen.dart';
import 'package:att_school/shared/widgets/layout/app_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReadClassDetailScreen extends StatelessWidget {
  const ReadClassDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ReadClassDetailProvider>(
      builder: (context, provider, _) {
        final class_ = "${provider.class_?.grade} - ${provider.class_?.name}";

        return Stack(
          children: [
            AppScreen(
              appBar: AppBar(title: const Text('Read Class Detail')),
              children: [
                AppText("Class Detail", variant: AppTextVariant.h2),
                AppButton(
                  "Update",
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return UpdateClassScreen(provider.class_?.id! ?? '');
                        },
                      ),
                    );
                    provider.reload();
                  },
                  variant: AppButtonVariant.primary,
                ),
                if (provider.class_ != null)
                  AppSection(
                    spacing: AppSize.xSmall,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: AppText(
                              "Kelas",
                              variant: AppTextVariant.body,
                            ),
                          ),
                          AppText(" : ", variant: AppTextVariant.body),
                          Expanded(
                            flex: 3,
                            child: AppText(
                              class_,
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
                            child: AppText(
                              "${provider.class_!.school!} aadaaaaaaaaaaaa",
                              variant: AppTextVariant.body,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
            if (provider.isLoading || provider.class_ == null)
              Container(
                color: Colors.black12,
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        );
      },
    );
  }
}
