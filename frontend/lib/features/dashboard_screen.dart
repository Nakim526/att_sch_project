import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/core/constant/size/app_spacing.dart';
import 'package:att_school/core/constant/size/screen/app_size_screen.dart';
import 'package:att_school/features/admin/dashboard_admin.dart';
import 'package:att_school/shared/styles/app_text_style.dart';
import 'package:att_school/shared/widgets/elements/app_text.dart';
import 'package:att_school/shared/widgets/elements/app_tile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _loadRoles();
  }

  Future<void> _loadRoles() async {
    final prefs = await SharedPreferences.getInstance();
    final roles = prefs.getString('roles');

    if (roles != null) {
      if (roles.contains("ADMIN")) {
        setState(() => _isAdmin = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Stack(
        children: [
          Container(
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
                      children: [
                        Icon(
                          Icons.person,
                          size: AppSizeScreen.iconCard(context),
                        ),
                        AppText(
                          "Profil",
                          variant: AppTextVariant.title,
                          maxLines: 2,
                        ),
                      ],
                    ),
                    AppTile(
                      onTap: () {},
                      children: [
                        Icon(
                          Icons.person,
                          size: AppSizeScreen.iconCard(context),
                        ),
                        AppText(
                          "Siswa",
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
                      onTap: () {},
                      maxWidth: AppSizeScreen.card(context),
                      children: [
                        Icon(
                          Icons.person,
                          size: AppSizeScreen.iconCard(context),
                        ),
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
                        Icon(
                          Icons.person,
                          size: AppSizeScreen.iconCard(context),
                        ),
                        AppText(
                          "Absen Siswa",
                          variant: AppTextVariant.title,
                          align: TextAlign.center,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (_isAdmin) const DashboardAdmin(),
        ],
      ),
    );
  }
}
