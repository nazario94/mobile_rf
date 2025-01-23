import 'package:flutter/services.dart';

class SignalStrengthService {
  static const _platform = MethodChannel('com.example.signal/signalStrength');

  // Method to get signal strength
  Future<String> getSignalStrength() async {
    try {
      final String signalStrength = await _platform.invokeMethod('getSignalStrength');
      return signalStrength;
    } on PlatformException catch (e) {
      return "Failed to get signal strength: '${e.message}'.";
    }
  }
}
