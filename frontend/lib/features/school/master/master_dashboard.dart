import 'package:att_school/core/constant/size/screen/app_size_screen.dart';
import 'package:att_school/shared/styles/app_text_style.dart';
import 'package:att_school/shared/widgets/elements/app_text.dart';
import 'package:att_school/shared/widgets/elements/card/app_card.dart';
import 'package:flutter/material.dart';

class MasterDashboard {
  const MasterDashboard._();

  static List<Widget> build(BuildContext context) {
    return [
      AppCard(
        onTap: () async {
          await Navigator.pushNamed(context, '/classes');
        },
        maxWidth: AppSizeScreen.card(context),
        children: [
          Icon(Icons.class_, size: AppSizeScreen.iconCard(context)),
          AppText("Kelas", variant: AppTextVariant.title, maxLines: 2),
        ],
      ),
      AppCard(
        onTap: () async {
          await Navigator.pushNamed(context, '/subjects');
        },
        maxWidth: AppSizeScreen.card(context),
        children: [
          Icon(Icons.subject, size: AppSizeScreen.iconCard(context)),
          AppText(
            "Mata Pelajaran",
            variant: AppTextVariant.title,
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
      AppCard(
        onTap: () async {
          await Navigator.pushNamed(context, '/students');
        },
        maxWidth: AppSizeScreen.card(context),
        children: [
          Icon(Icons.person, size: AppSizeScreen.iconCard(context)),
          AppText(
            "Siswa",
            variant: AppTextVariant.title,
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
      AppCard(
        onTap: () async {
          await Navigator.pushNamed(context, '/teachers');
        },
        maxWidth: AppSizeScreen.card(context),
        children: [
          Icon(Icons.person, size: AppSizeScreen.iconCard(context)),
          AppText("Guru", variant: AppTextVariant.title, maxLines: 2),
        ],
      ),
      AppCard(
        onTap: () async {
          await Navigator.pushNamed(context, '/semesters');
        },
        maxWidth: AppSizeScreen.card(context),
        children: [
          Icon(Icons.book, size: AppSizeScreen.iconCard(context)),
          AppText(
            "Semester",
            variant: AppTextVariant.title,
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
      AppCard(
        onTap: () async {
          await Navigator.pushNamed(context, '/academic-years');
        },
        maxWidth: AppSizeScreen.card(context),
        children: [
          Icon(Icons.book, size: AppSizeScreen.iconCard(context)),
          AppText(
            "Tahun Akademik",
            variant: AppTextVariant.title,
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
      AppCard(
        onTap: () async {
          await Navigator.pushNamed(context, '/users');
        },
        maxWidth: AppSizeScreen.card(context),
        children: [
          Icon(Icons.security, size: AppSizeScreen.iconCard(context)),
          AppText("Hak Akses", variant: AppTextVariant.title, maxLines: 2),
        ],
      ),
    ];
  }
}
