import 'package:att_school/core/constant/size/screen/app_size_screen.dart';
import 'package:att_school/features/auth/provider/auth_provider.dart';
import 'package:att_school/shared/styles/app_button_style.dart';
import 'package:att_school/shared/styles/app_text_style.dart';
import 'package:att_school/shared/widgets/elements/button/app_button.dart';
import 'package:att_school/shared/widgets/elements/app_text.dart';
import 'package:att_school/shared/widgets/elements/dialog/app_dialog.dart';
import 'package:att_school/shared/widgets/layout/app_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthLoginScreen extends StatelessWidget {
  const AuthLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, provider, _) {
        return Stack(
          children: [
            AppScreen(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: AppSizeScreen.height(context) * 0.1),
                AppText(
                  'SD INPRES PANNYIKOKANG',
                  textAlign: TextAlign.center,
                  variant: AppTextVariant.h1,
                ),
                Image.asset(
                  'assets/images/kemendikbud.png',
                  height: 200,
                  cacheHeight: 200,
                ),
                AppButton(
                  'Masuk dengan Google',
                  variant: AppButtonVariant.primary,
                  onPressed: () async {
                    final result = await provider.login();
                    if (context.mounted) {
                      if (result.status) {
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
            if (provider.isLoading)
              Container(
                color: Colors.black45,
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        );
      },
    );
  }
}
