class AuthManager {
  AuthManager._();

  static String? _idToken;

  static void setCredential(String token) {
    _idToken = 'Basic $token';
  }

  static String? get idToken => _idToken;

  static void clear() {
    _idToken = null;
  }
}
