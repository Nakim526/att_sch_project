import 'package:att_school/features/auth/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthLoginScreen extends StatelessWidget {
  const AuthLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Login')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final loggedIn = await provider.login();
                    if (loggedIn) {
                      Navigator.pushReplacementNamed(context, '/dashboard');
                    }
                  },
                  child:
                      provider.isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Login'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
