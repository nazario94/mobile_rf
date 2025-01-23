import 'package:flutter/services.dart';

class SignalStrength {
  static const platform = MethodChannel('com.example.signal_strength');

  static Future<int?> getSignalStrength() async {
    try {
      final int? signalStrength = await platform.invokeMethod('getSignalStrength');
      return signalStrength;
    } on PlatformException catch (e) {
      print("Failed to get signal strength: '${e.message}'.");
      return null;
    }
  }
}
