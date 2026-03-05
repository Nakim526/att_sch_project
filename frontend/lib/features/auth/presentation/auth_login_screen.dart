import 'package:att_school/core/constant/size/screen/app_size_screen.dart';
import 'package:att_school/features/auth/data/auth_model.dart';
import 'package:att_school/features/auth/provider/auth_provider.dart';
import 'package:att_school/shared/styles/app_button_style.dart';
import 'package:att_school/shared/widgets/elements/button/app_button.dart';
import 'package:att_school/shared/widgets/elements/dialog/app_dialog.dart';
import 'package:att_school/shared/widgets/elements/input/text/app_text_input.dart';
import 'package:att_school/shared/widgets/layout/app_loading.dart';
import 'package:att_school/shared/widgets/layout/app_screen.dart';
import 'package:att_school/shared/widgets/layout/app_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthLoginScreen extends StatefulWidget {
  const AuthLoginScreen({super.key});

  @override
  State<AuthLoginScreen> createState() => _AuthLoginScreenState();
}

class _AuthLoginScreenState extends State<AuthLoginScreen> {
  final _schoolNameController = TextEditingController();
  bool _errorSchoolName = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _schoolNameController.dispose();
    super.dispose();
  }

  void _onChangedSchoolName(_) {
    if (_errorSchoolName) setState(() => _errorSchoolName = false);
  }

  bool _validate() {
    setState(() => _errorSchoolName = _schoolNameController.text.isEmpty);

    return !(_errorSchoolName);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop || auth.isLoading || _isLoading) return;

        await AppDialog.confirm(
          context,
          title: 'Keluar Aplikasi',
          message: 'Apakah kamu yakin ingin keluar dari aplikasi?',
          exit: true,
        );
      },
      child: Stack(
        children: [
          AppScreen(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: AppSizeScreen.height(context) * 0.1),
              Image.asset(
                'assets/images/kemendikbud.png',
                height: 200,
                cacheHeight: 200,
              ),
              AppSection(
                children: [
                  AppTextInput(
                    controller: _schoolNameController,
                    labelText: 'Nama Sekolah',
                    errorText: 'Nama Sekolah tidak boleh kosong.',
                    isError: _errorSchoolName,
                    onChanged: _onChangedSchoolName,
                  ),
                ],
              ),
              AppButton(
                'Masuk dengan Google',
                variant: AppButtonVariant.primary,
                onPressed: () async {
                  if (!_validate() || _isLoading) return;

                  setState(() => _isLoading = true);

                  final auth = context.read<AuthProvider>();

                  final result = await auth.login(
                    AuthModel(schoolName: _schoolNameController.text.trim()),
                  );

                  if (context.mounted) {
                    setState(() => _isLoading = false);

                    if (result.status) {
                      if (!context.mounted) return;

                      Navigator.pushNamed(context, '/dashboard');
                      return;
                    }

                    await AppDialog.show(
                      context,
                      title: 'Error',
                      message: result.message,
                    );
                  }
                },
                prefixIcon: Image.asset('assets/icons/google.png', width: 24),
              ),
            ],
          ),
          if (auth.isLoading || _isLoading) AppLoading(),
        ],
      ),
    );
  }
}
