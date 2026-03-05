import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/features/admin/school/delete/provider/delete_school_provider.dart';
import 'package:att_school/features/admin/school/read/detail/presentation/read_school_detail_page.dart';
import 'package:att_school/features/admin/school/read/list/provider/read_school_list_provider.dart';
import 'package:att_school/shared/styles/app_button_style.dart';
import 'package:att_school/shared/styles/app_text_style.dart';
import 'package:att_school/shared/widgets/elements/app_text.dart';
import 'package:att_school/shared/widgets/elements/button/app_button.dart';
import 'package:att_school/shared/widgets/elements/dialog/app_dialog.dart';
import 'package:att_school/shared/widgets/layout/app_loading.dart';
import 'package:att_school/shared/widgets/layout/app_screen.dart';
import 'package:att_school/shared/widgets/layout/app_search.dart';
import 'package:att_school/shared/widgets/layout/app_table_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReadSchoolListScreen extends StatelessWidget {
  const ReadSchoolListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<DeleteSchoolProvider>();

    return Consumer<ReadSchoolListProvider>(
      builder: (context, list, _) {
        // 🔥 SIDE-EFFECT: dialog
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (list.error.isNotEmpty) {
            AppDialog.show(context, title: 'Error', message: list.error);

            // penting: reset error
            list.clearError();
          }
        });

        return Stack(
          children: [
            AppScreen(
              appBar: AppBar(title: const Text('Read School List')),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSize.medium,
                  children: [
                    AppText("School List", variant: AppTextVariant.h2),
                    AppButton(
                      "Create School",
                      onPressed: () async {
                        await Navigator.pushNamed(context, '/schools/create');
                        await list.reload();
                      },
                      variant: AppButtonVariant.primary,
                    ),
                    AppSearch(onChanged: list.search),
                    AppTableList(
                      columns: {'Name': 'name', 'Email': 'email'},
                      data: list.data,
                      cellLink: ['name'],
                      onDetail: (id) async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ReadSchoolDetailPage(id),
                          ),
                        );

                        await list.reload();
                      },
                      onRemove: (detail) {
                        AppDialog.confirm(
                          context,
                          title: 'Delete Data',
                          message: "Are you sure to delete this record?",
                          onConfirm: () async {
                            final result = await provider.deleteSchool(
                              detail['id'],
                            );

                            if (result.status) {
                              return await list.reload();
                            }

                            if (context.mounted) {
                              await AppDialog.show(
                                context,
                                title: "Error",
                                message: result.message,
                              );
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            if (list.isLoading || list.data.isEmpty) AppLoading(),
          ],
        );
      },
    );
  }
}
