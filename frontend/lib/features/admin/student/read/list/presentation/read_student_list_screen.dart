import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/features/admin/student/delete/provider/delete_student_provider.dart';
import 'package:att_school/features/admin/student/read/detail/presentation/read_student_detail_page.dart';
import 'package:att_school/features/admin/student/read/list/provider/read_student_list_provider.dart';
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

class ReadStudentListScreen extends StatelessWidget {
  const ReadStudentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<DeleteStudentProvider>();

    return Consumer<ReadStudentListProvider>(
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
              appBar: AppBar(title: const Text('Read Student List')),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSize.medium,
                  children: [
                    AppText("Student List", variant: AppTextVariant.h2),
                    AppButton(
                      "Create Student",
                      onPressed: () async {
                        await Navigator.pushNamed(context, '/students/create');

                        await list.reload();
                      },
                      variant: AppButtonVariant.primary,
                    ),
                    AppSearch(onChanged: list.search),
                    AppTableList(
                      columns: {
                        'NIS': 'nis',
                        'Nama': 'name',
                        'Jenis Kelamin': 'gender',
                        'Status': 'isActive',
                      },
                      data: list.students,
                      cellLink: ['name'],
                      customData: {
                        'isActive': (v) => v ? 'Aktif' : 'Tidak Aktif',
                      },
                      onDetail: (id) async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ReadStudentDetailPage(id),
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
                            final result = await provider.deleteStudent(
                              detail['id'],
                            );

                            if (result.status) {
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
