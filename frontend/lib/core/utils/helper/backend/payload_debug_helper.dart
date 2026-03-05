import 'package:att_school/core/utils/helper/backend/backend_message_helper.dart';
import 'package:flutter/foundation.dart';

class PayloadDebugHelper {
  final dynamic payload;

  PayloadDebugHelper(this.payload);

  BackendMessageHelper show() {
    debugPrint(payload.toString());

    return BackendMessageHelper(false, message: payload.toString());
  }
}
