import 'package:att_school/core/constant/size/screen/app_size_screen.dart';
import 'package:att_school/features/school/master/teacher/read/detail/presentation/read_teacher_detail_page.dart';
import 'package:att_school/shared/styles/app_text_style.dart';
import 'package:att_school/shared/widgets/elements/app_text.dart';
import 'package:att_school/shared/widgets/elements/card/app_card.dart';
import 'package:flutter/material.dart';

class TeacherDashboard {
  const TeacherDashboard._();

  static List<Widget> personal(BuildContext context) => [
    AppCard(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ReadTeacherDetailPage('me')),
        );
      },
      children: [
        Icon(Icons.person, size: AppSizeScreen.iconCard(context)),
        AppText("Data Guru", variant: AppTextVariant.title, maxLines: 2),
      ],
    ),
    AppCard(
      onTap: () {
        Navigator.pushNamed(context, '/classes/me');
      },
      children: [
        Icon(Icons.person, size: AppSizeScreen.iconCard(context)),
        AppText("Kelas Saya", variant: AppTextVariant.title, maxLines: 2),
      ],
    ),
  ];

  static List<Widget> build(BuildContext context) => [
    AppCard(
      onTap: () {},
      maxWidth: AppSizeScreen.card(context),
      children: [
        Icon(Icons.person, size: AppSizeScreen.iconCard(context)),
        AppText("Absen Guru", variant: AppTextVariant.title, maxLines: 2),
      ],
    ),
    AppCard(
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
  ];
}
