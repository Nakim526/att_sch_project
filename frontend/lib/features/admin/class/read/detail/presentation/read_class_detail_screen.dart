import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/features/admin/class/read/detail/provider/read_class_detail_provider.dart';
import 'package:att_school/features/admin/class/update/presentation/update_class_screen.dart';
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

class ReadClassDetailScreen extends StatelessWidget {
  const ReadClassDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ReadClassDetailProvider>(
      builder: (context, provider, _) {
        final detail = provider.class_;
        final class_ = "${detail?.grade} - ${detail?.name}";

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
                if (detail != null)
                  AppSection(
                    spacing: AppSize.xSmall,
                    children: [
                      AppField('Kelas', value: class_),
                      AppField('Sekolah', value: detail.school!),
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
