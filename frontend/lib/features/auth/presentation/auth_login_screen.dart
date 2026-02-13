import 'package:att_school/core/constant/size/app_size.dart';
import 'package:att_school/features/auth/provider/auth_provider.dart';
import 'package:att_school/shared/widgets/elements/app_button.dart';
import 'package:att_school/shared/widgets/elements/app_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthLoginScreen extends StatelessWidget {
  const AuthLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          body: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: AppSize.large,
              children: [
                AppText(
                  'SD INPRES PANNYIKOKANG',
                  align: TextAlign.center,
                  variant: AppTextVariant.h1,
                ),
                Image.asset(
                  'assets/images/kemendikbud.png',
                  height: 200,
                  cacheHeight: 200,
                ),
                AppButton(
                  'Masuk dengan Google',
                  variant: AppButtonVariant.secondary,
                  onPressed: () async {
                    final loggedIn = await provider.login();
                    if (loggedIn && context.mounted) {
                      Navigator.pushNamed(context, '/dashboard');
                    }
                  },
                  prefixIcon: Image.asset('assets/icons/google.png', width: 24),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
