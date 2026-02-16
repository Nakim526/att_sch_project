import 'package:att_school/core/constant/size/screen/app_size_screen.dart';
import 'package:att_school/shared/styles/app_text_style.dart';
import 'package:att_school/shared/widgets/elements/app_text.dart';
import 'package:att_school/shared/widgets/elements/app_tile.dart';
import 'package:att_school/shared/widgets/layout/app_screen.dart';
import 'package:flutter/material.dart';

class DashboardAdmin extends StatelessWidget {
  const DashboardAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      appBar: AppBar(title: const Text('Dashboard Admin')),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppTile(
              onTap: () {
                Navigator.pushNamed(context, '/classes');
              },
              maxWidth: AppSizeScreen.card(context),
              children: [
                Icon(Icons.class_, size: AppSizeScreen.iconCard(context)),
                AppText("Kelas", variant: AppTextVariant.title, maxLines: 2),
              ],
            ),
            AppTile(
              onTap: () {
                Navigator.pushNamed(context, '/has-access');
              },
              maxWidth: AppSizeScreen.card(context),
              children: [
                Icon(Icons.security, size: AppSizeScreen.iconCard(context)),
                AppText(
                  "Hak Akses",
                  variant: AppTextVariant.title,
                  maxLines: 2,
                ),
              ],
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppTile(
              onTap: () {
                Navigator.pushNamed(context, '/teachers');
              },
              maxWidth: AppSizeScreen.card(context),
              children: [
                Icon(
                  Icons.person_add_alt_1,
                  size: AppSizeScreen.iconCard(context),
                ),
                AppText("Guru", variant: AppTextVariant.title, maxLines: 2),
              ],
            ),
            AppTile(
              onTap: () {},
              maxWidth: AppSizeScreen.card(context),
              children: [
                Icon(
                  Icons.person_add_alt_1,
                  size: AppSizeScreen.iconCard(context),
                ),
                AppText("Siswa", variant: AppTextVariant.title, maxLines: 2),
              ],
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppTile(
              onTap: () {},
              maxWidth: AppSizeScreen.card(context),
              children: [
                Icon(Icons.person, size: AppSizeScreen.iconCard(context)),
                AppText(
                  "Absen Guru",
                  variant: AppTextVariant.title,
                  maxLines: 2,
                ),
              ],
            ),
            AppTile(
              onTap: () {},
              maxWidth: AppSizeScreen.card(context),
              children: [
                Icon(Icons.person, size: AppSizeScreen.iconCard(context)),
                AppText(
                  "Absen Siswa",
                  variant: AppTextVariant.title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
