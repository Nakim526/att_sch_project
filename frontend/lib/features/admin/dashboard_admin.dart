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
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.725, // atur tinggi card
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
                Navigator.pushNamed(context, '/subjects');
              },
              maxWidth: AppSizeScreen.card(context),
              children: [
                Icon(Icons.subject, size: AppSizeScreen.iconCard(context)),
                AppText(
                  "Mata Pelajaran",
                  variant: AppTextVariant.title,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
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
      ],
    );
  }
}
