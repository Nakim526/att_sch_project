import 'package:att_school/core/constant/item/app_items.dart';
import 'package:att_school/core/constant/size/screen/app_size_screen.dart';
import 'package:att_school/core/utils/helper/provider/provider_helper.dart';
import 'package:att_school/features/admin/admin_dashboard.dart';
import 'package:att_school/features/auth/provider/auth_provider.dart';
import 'package:att_school/features/auth/roles/provider/roles_provider.dart';
import 'package:att_school/features/school/master/master_dashboard.dart';
import 'package:att_school/features/school/master/user/read/detail/presentation/read_user_detail_page.dart';
import 'package:att_school/features/school/teacher/teacher_dashboard.dart';
import 'package:att_school/shared/styles/app_text_style.dart';
import 'package:att_school/shared/widgets/elements/app_text.dart';
import 'package:att_school/shared/widgets/elements/card/app_card.dart';
import 'package:att_school/shared/widgets/elements/dialog/app_dialog.dart';
import 'package:att_school/shared/widgets/layout/app_loading.dart';
import 'package:att_school/shared/widgets/layout/app_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Widget>? _children;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<ProviderHelper>().reload();

      await _loadRoles();
    });
  }

  Future<void> _loadRoles() async {
    List<Widget> dashboard = [];

    if (!mounted) return;

    debugPrint(RolesProvider.me.isAdmin.toString());

    if (RolesProvider.me.isAdmin) {
      if (!AppItems.roles.contains(AppItems.kepsek)) {
        AppItems.roles.add(AppItems.kepsek);
      }
      if (!AppItems.roles.contains(AppItems.admin)) {
        AppItems.roles.add(AppItems.admin);
      }
    } else {
      AppItems.roles.remove(AppItems.kepsek);
      AppItems.roles.remove(AppItems.admin);
    }
    debugPrint(RolesProvider.me.toListString().toString());

    if (!mounted) return;

    if (RolesProvider.me.isAdmin || RolesProvider.me.isPrincipal) {
      dashboard.addAll([
        _personal,
        ...(RolesProvider.me.andTeacher
            ? TeacherDashboard.personal(context)
            : []),
        ...TeacherDashboard.build(context),
        ...MasterDashboard.build(context),
        AdminDashboard.build(context),
      ]);
    } else if (RolesProvider.me.isOperator) {
      if (RolesProvider.me.andTeacher) {
        dashboard.addAll([
          _personal,
          ...TeacherDashboard.personal(context),
          ...TeacherDashboard.build(context),
        ]);
      }
      dashboard.addAll(MasterDashboard.build(context));
    } else {
      dashboard.addAll([
        _personal,
        ...TeacherDashboard.personal(context),
        ...TeacherDashboard.build(context),
      ]);
    }

    setState(() {
      _isLoading = false;
      _children = dashboard;
    });
  }

  Widget get _personal => AppCard(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ReadUserDetailPage('me')),
      );
    },
    children: [
      Icon(Icons.person, size: AppSizeScreen.iconCard(context)),
      AppText("Data Pribadi", variant: AppTextVariant.title, maxLines: 2),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        Future.microtask(() async {
          if (!context.mounted) return;
          final auth = context.read<AuthProvider>();

          final exit = await AppDialog.confirm(
            context,
            title: 'Keluar Aplikasi',
            message: 'Apakah kamu yakin ingin keluar dari aplikasi?',
            // exit: true,
          );

          if (exit) {
            await auth.logout();

            if (!context.mounted) return;
            Navigator.pop(context);
          }
        });
      },
      child: Stack(
        children: [
          AppScreen(
            appBar: AppBar(title: const Text('Dashboard')),
            children: [
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.725, // atur tinggi card
                children: _children ?? [],
              ),
            ],
          ),
          if (_isLoading) AppLoading(),
        ],
      ),
    );
  }
}
