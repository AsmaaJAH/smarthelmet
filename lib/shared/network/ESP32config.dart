import 'dart:io';

import 'package:esp_smartconfig/esp_smartconfig.dart';

void main() async {
  final provisioner = Provisioner.espTouch();

  provisioner.listen((response) {
    print("Device ($response) is connected to WiFi!");
  });

  await provisioner.start(ProvisioningRequest.fromStrings(
    ssid: "7b4aapa",
    bssid: "cc:32:e5:6c:42:46",
    password: "NETWORK_PASSWORD_GOES_HERE",
  ));

  await Future.delayed(Duration(seconds: 10));

  provisioner.stop();
  exit(0);
}