import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/features/school/master/user/delete/provider/delete_user_provider.dart';
import 'package:att_school/features/school/master/user/read/detail/presentation/read_user_detail_page.dart';
import 'package:att_school/features/school/master/user/read/list/provider/read_user_list_provider.dart';
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

class ReadUserListScreen extends StatelessWidget {
  const ReadUserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final delete = context.watch<DeleteUserProvider>();

    return Consumer<ReadUserListProvider>(
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
              appBar: AppBar(title: const Text('Read User List')),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSize.medium,
                  children: [
                    AppText("User List", variant: AppTextVariant.h2),
                    AppButton(
                      "Create User",
                      onPressed: () async {
                        await Navigator.pushNamed(context, '/users/create');
                        await list.reload();
                      },
                      variant: AppButtonVariant.primary,
                    ),
                    AppSearch(onChanged: list.search),
                    AppTableList(
                      columns: {
                        'Name': 'name',
                        'Email': 'email',
                        'Status': 'isActive',
                        'Hak Akses': 'role',
                      },
                      customData: {
                        'isActive': (value) {
                          return value ? 'Aktif' : 'Tidak Aktif';
                        },
                      },
                      data: list.data,
                      cellLink: ['name'],
                      onDetail: (id) async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ReadUserDetailPage(id),
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
                            final provider = context.read<DeleteUserProvider>();

                            final result = await provider.deleteUser(
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
                    Column(children: [
                      ],
                    ),
                  ],
                ),
              ],
            ),
            if (list.isLoading || delete.isLoading) AppLoading(),
          ],
        );
      },
    );
  }
}
