import 'package:att_school/core/constant/size/screen/app_size_screen.dart';
import 'package:att_school/features/admin/school/read/detail/presentation/read_school_detail_page.dart';
import 'package:att_school/features/auth/roles/provider/roles_provider.dart';
import 'package:att_school/shared/styles/app_text_style.dart';
import 'package:att_school/shared/widgets/elements/app_text.dart';
import 'package:att_school/shared/widgets/elements/card/app_card.dart';
import 'package:flutter/material.dart';

class AdminDashboard {
  const AdminDashboard._();

  static Widget build(BuildContext context) {
    return AppCard(
      onTap: () async {
        if (!context.mounted) return;

        debugPrint(RolesProvider.me.isAdmin.toString());
        debugPrint(RolesProvider.me.isPrincipal.toString());

        if (RolesProvider.me.isAdmin) {
          await Navigator.pushNamed(context, '/schools');
        } else {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ReadSchoolDetailPage('me')),
          );
        }
      },
      maxWidth: AppSizeScreen.card(context),
      children: [
        Icon(Icons.school, size: AppSizeScreen.iconCard(context)),
        AppText("Sekolah", variant: AppTextVariant.title, maxLines: 2),
      ],
    );
  }
}
