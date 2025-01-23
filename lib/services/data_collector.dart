import 'package:geolocator/geolocator.dart';
import 'database_helper.dart';

class DataCollector {
  static Future<void> collectData() async {
    Position position = await Geolocator.getCurrentPosition();
    int rssi = getSignalStrength();

    Map<String, dynamic> data = {
      'latitude': position.latitude,
      'longitude': position.longitude,
      'rssi': rssi,
      'timestamp': DateTime.now().toString(),
    };

    await DatabaseHelper.instance.insertData(data);
  }

  static int getSignalStrength() {
    // Example function, replace with actual implementation
    return -70; // Mock signal strength in dBm
  }
}
