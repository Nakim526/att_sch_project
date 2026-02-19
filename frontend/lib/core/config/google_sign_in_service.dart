import 'package:att_school/core/constant/string/app_string.dart';
import 'package:att_school/core/utils/helper/backend_message_helper.dart';
import 'package:att_school/core/utils/helper/connection_helper.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  const GoogleSignInService._();

  static final GoogleSignInService instance = GoogleSignInService._();

  static Future<BackendMessageHelper> login() async {
    final hasConnectionInternet = await ConnectionHelper.check();

    if (!hasConnectionInternet) {
      return BackendMessageHelper(false, message: 'No internet connection');
    }

    final googleSignIn = GoogleSignIn.instance;
    
    try {
      await googleSignIn.initialize(
        clientId: AppString.clientId,
        serverClientId: AppString.serverClientId,
      );

      final user = await googleSignIn.authenticate();

      final auth = user.authentication;

      if (auth.idToken != null) {
        return BackendMessageHelper(true, data: auth.idToken);
      }

      return BackendMessageHelper(false, message: 'Unauthorized');
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return BackendMessageHelper(false, message: 'Login canceled by user');
      }

      return BackendMessageHelper(false, message: e.code.toString());
    }
  }

  static Future<void> logout() async {
    final GoogleSignIn googleSignIn = GoogleSignIn.instance;
    await googleSignIn.signOut();
  }
}
