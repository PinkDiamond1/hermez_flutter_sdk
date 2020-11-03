import 'dart:async';

import 'package:flutter/services.dart';

class HermezPlugin {
  static const MethodChannel _channel = const MethodChannel('hermez_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
