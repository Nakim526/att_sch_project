import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/features/school/master/class/read/detail/presentation/read_class_detail_page.dart';
import 'package:att_school/features/school/teacher/my-class/list/provider/read_my_class_list_provider.dart';
import 'package:att_school/shared/styles/app_text_style.dart';
import 'package:att_school/shared/widgets/elements/app_text.dart';
import 'package:att_school/shared/widgets/elements/dialog/app_dialog.dart';
import 'package:att_school/shared/widgets/layout/app_loading.dart';
import 'package:att_school/shared/widgets/layout/app_screen.dart';
import 'package:att_school/shared/widgets/layout/app_search.dart';
import 'package:att_school/shared/widgets/layout/app_table_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReadMyClassListScreen extends StatelessWidget {
  const ReadMyClassListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ReadMyClassListProvider>(
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
              appBar: AppBar(title: const Text('My Class List')),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSize.medium,
                  children: [
                    AppText("My Class List", variant: AppTextVariant.h2),
                    AppSearch(onChanged: list.search),
                    AppTableList(
                      columns: {'Grade': 'gradeLevel', 'Nama Kelas': 'name'},
                      data: list.data,
                      cellLink: ['name'],
                      hasAction: false,
                      onDetail: (id) async {
                        String? teacherId;

                        for (final e in list.data) {
                          if (e['id'] == id) teacherId = e['teacherId'];
                        }

                        debugPrint('teacherId: $teacherId');
                        debugPrint('ID: $id');

                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) {
                              return ReadClassDetailPage(
                                id,
                                teacherId: teacherId,
                              );
                            },
                          ),
                        );

                        await list.reload();
                      },
                      onRemove: (_) {},
                    ),
                  ],
                ),
              ],
            ),
            if (list.isLoading) AppLoading(),
          ],
        );
      },
    );
  }
}
