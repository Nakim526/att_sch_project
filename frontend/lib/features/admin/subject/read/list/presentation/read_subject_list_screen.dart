import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/features/admin/subject/delete/provider/delete_subject_provider.dart';
import 'package:att_school/features/admin/subject/read/detail/presentation/read_subject_detail_page.dart';
import 'package:att_school/features/admin/subject/read/list/provider/read_subject_list_provider.dart';
import 'package:att_school/shared/styles/app_button_style.dart';
import 'package:att_school/shared/styles/app_text_style.dart';
import 'package:att_school/shared/widgets/elements/app_text.dart';
import 'package:att_school/shared/widgets/elements/button/app_button.dart';
import 'package:att_school/shared/widgets/elements/dialog/app_dialog.dart';
import 'package:att_school/shared/widgets/layout/app_screen.dart';
import 'package:att_school/shared/widgets/layout/app_search.dart';
import 'package:att_school/shared/widgets/layout/app_table_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReadSubjectListScreen extends StatelessWidget {
  const ReadSubjectListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<DeleteSubjectProvider>();

    return Consumer<ReadSubjectListProvider>(
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
              appBar: AppBar(title: const Text('Read Subject List')),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSize.medium,
                  children: [
                    AppText("Subject List", variant: AppTextVariant.h2),
                    AppButton(
                      "Create Subject",
                      onPressed: () async {
                        await Navigator.pushNamed(context, '/subjects/create');

                        await list.reload();
                      },
                      variant: AppButtonVariant.primary,
                    ),
                    AppSearch(onChanged: list.search),
                    AppTableList(
                      columns: {'Subject': 'name', '': ''},
                      data: list.subjects,
                      cellLink: ['name'],
                      onDetail: (id) async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ReadSubjectDetailPage(id),
                          ),
                        );

                        await list.reload();
                      },
                      onRemove: (detail) {
                        AppDialog.confirm(
                          context,
                          title: 'Delete Data',
                          message: "Are you sure to delete ${detail['name']}?",
                          onConfirm: () async {
                            final result = await provider.deleteSubject(
                              detail['id'],
                            );

                            if (result.success) {
                              return list.reload();
                            }

                            if (context.mounted) {
                              AppDialog.show(
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
            if (list.isLoading)
              Container(
                color: Colors.black45,
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        );
      },
    );
  }
}
