import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/core/constant/size/app_spacing.dart';
import 'package:att_school/core/constant/size/screen/app_size_screen.dart';
import 'package:att_school/shared/widgets/elements/app_text.dart';
import 'package:att_school/shared/widgets/elements/app_tile.dart';
import 'package:flutter/material.dart';

class DashboardAdmin extends StatelessWidget {
  const DashboardAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.large,
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: AppSize.large,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppTile(
                onTap: () {},
                child: Column(
                  children: [
                    Icon(Icons.class_, size: AppSizeScreen.card(context)),
                    AppText("Kelas", variant: AppTextVariant.title),
                  ],
                ),
              ),
              AppTile(
                onTap: () {},
                child: Column(
                  children: [
                    Icon(Icons.security, size: AppSizeScreen.card(context)),
                    AppText("Hak Akses", variant: AppTextVariant.title),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppTile(
                onTap: () {},
                child: Column(
                  children: [
                    Icon(Icons.person_add_alt_1, size: AppSizeScreen.card(context)),
                    AppText("Guru", variant: AppTextVariant.title),
                  ],
                ),
              ),
              AppTile(
                onTap: () {},
                child: Column(
                  children: [
                    Icon(
                      Icons.person_add_alt_1,
                      size: AppSizeScreen.card(context),
                    ),
                    AppText("Siswa", variant: AppTextVariant.title),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppTile(
                onTap: () {},
                child: Column(
                  children: [
                    Icon(Icons.person, size: AppSizeScreen.card(context)),
                    AppText("Absen Guru", variant: AppTextVariant.title),
                  ],
                ),
              ),
              AppTile(
                onTap: () {},
                child: Column(
                  children: [
                    Icon(Icons.person, size: AppSizeScreen.card(context)),
                    AppText("Absen Siswa", variant: AppTextVariant.title),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
