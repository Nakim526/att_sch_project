import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/features/admin/has-access/read/detail/provider/read_has_access_detail_provider.dart';
import 'package:att_school/features/admin/has-access/update/presentation/update_has_acccess_screen.dart';
import 'package:att_school/shared/styles/app_button_style.dart';
import 'package:att_school/shared/styles/app_text_style.dart';
import 'package:att_school/shared/widgets/elements/app_text.dart';
import 'package:att_school/shared/widgets/elements/button/app_button.dart';
import 'package:att_school/shared/widgets/layout/app_loading.dart';
import 'package:att_school/shared/widgets/layout/app_screen.dart';
import 'package:att_school/shared/widgets/layout/app_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReadHasAccessDetailScreen extends StatelessWidget {
  const ReadHasAccessDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ReadHasAccessDetailProvider>(
      builder: (context, provider, _) {
        final detail = provider.hasAccess;

        return Stack(
          children: [
            AppScreen(
              appBar: AppBar(title: const Text('Read HasAccess Detail')),
              children: [
                AppText("HasAccess Detail", variant: AppTextVariant.h2),
                AppButton(
                  "Update",
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return UpdateHasAccessScreen(detail?.id! ?? '');
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
                      Row(
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
                              "Email",
                              variant: AppTextVariant.body,
                            ),
                          ),
                          AppText(" : ", variant: AppTextVariant.body),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (detail.roles!.length > 1)
                                  ...detail.roles!.map(
                                    (e) => AppText(
                                      "- ${e.role!}",
                                      variant: AppTextVariant.body,
                                    ),
                                  )
                                else
                                  AppText(
                                    detail.roles!.first.role!,
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
            if (provider.isLoading || provider.hasAccess == null) AppLoading(),
          ],
        );
      },
    );
  }
}
