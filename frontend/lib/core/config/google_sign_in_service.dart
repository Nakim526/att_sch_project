import 'package:att_school/core/constant/string/app_string.dart';
import 'package:att_school/core/utils/helper/connection_helper.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  const GoogleSignInService._();

  static final GoogleSignInService instance = GoogleSignInService._();

  static Future<String?> login() async {
    final hasConnectionInternet = await ConnectionHelper.check();

    if (!hasConnectionInternet) {
      throw 'No internet connection';
    }

    final googleSignIn = GoogleSignIn.instance;
    try {
      await googleSignIn.initialize(
        clientId: AppString.clientId,
        serverClientId: AppString.serverClientId,
      );

      final user = await googleSignIn.authenticate();

      final auth = user.authentication;

      return auth.idToken;
    } on GoogleSignInException catch (e) {
      if (e.code.toString() == 'GoogleSignInExceptionCode.canceled') {
        throw 'Login canceled by user';
      }
      throw e.code.toString();
    }
  }

  static Future<void> logout() async {
    final GoogleSignIn googleSignIn = GoogleSignIn.instance;
    await googleSignIn.signOut();
  }
}
