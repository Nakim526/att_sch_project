import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionHelper {
  const ConnectionHelper._();
  
  static Future<bool> check() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.none)) {
      return false;
    }

    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    }
  }
}
