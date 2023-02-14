import "dart:math" as math;

import "package:base32/base32.dart";
import "package:dart_dash_otp/dart_dash_otp.dart";
import "package:flutter/services.dart";
import "package:get/get.dart";

class HomeController extends GetxController {
  final Rx<TOTP> totp = TOTP(secret: "").obs;

  void setTOTP() {
    totp(TOTP(secret: randomSecret()));
    return;
  }

  String randomSecret() {
    final math.Random rand = math.Random.secure();
    final List<int> bytes = <int>[];
    for (int i = 0; i < 10; i++) {
      bytes.add(rand.nextInt(256));
    }
    return base32.encode(Uint8List.fromList(bytes));
  }
}
