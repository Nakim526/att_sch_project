import 'package:att_school/features/admin/school/read/detail/provider/read_school_detail_provider.dart';
import 'package:att_school/features/admin/school/update/presentation/update_school_screen.dart';
import 'package:att_school/features/auth/roles/provider/roles_provider.dart';
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

class ReadSchoolDetailScreen extends StatelessWidget {
  const ReadSchoolDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ReadSchoolDetailProvider>(
      builder: (context, provider, _) {
        final detail = provider.data;

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
              appBar: AppBar(title: const Text('Read School Detail')),
              children: [
                AppText("School Detail", variant: AppTextVariant.h2),
                AppButton(
                  "Update",
                  onPressed: () async {
                    if (detail == null) return;

                    String? id = detail.id;

                    if (!RolesProvider.me.isAdmin) id = 'me';

                    if (!context.mounted) return;

                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return UpdateSchoolScreen(id!);
                        },
                      ),
                    );

                    await provider.reload();
                  },
                  variant: AppButtonVariant.primary,
                ),
                if (detail != null) ...{
                  AppSection(
                    title: 'Data Sekolah',
                    children: [
                      AppField('Nama', value: detail.name),
                      AppField('Alamat', value: detail.address),
                      AppField('Nomor Telepon', value: detail.phone),
                      AppField('Email', value: detail.email),
                    ],
                  ),
                  AppSection(
                    title: 'Kepala Sekolah',
                    children: [
                      AppField('Nama', value: detail.principalName),
                      AppField('Email', value: detail.principalEmail),
                    ],
                  ),
                },
              ],
            ),
            if (provider.isLoading || detail == null) AppLoading(),
          ],
        );
      },
    );
  }
}
