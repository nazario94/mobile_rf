class RFData {
  final double latitude;
  final double longitude;
  final int rssi;
  final String cellId;
  final String timestamp;

  RFData({required this.latitude, required this.longitude, required this.rssi, required this.cellId, required this.timestamp});

  // Convert a Map into an RFData object
  factory RFData.fromMap(Map<String, dynamic> map) {
    return RFData(
      latitude: map['latitude'],
      longitude: map['longitude'],
      rssi: map['rssi'],
      cellId: map['cell_id'],
      timestamp: map['timestamp'],
    );
  }

  // Convert RFData object to Map
  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'rssi': rssi,
      'cell_id': cellId,
      'timestamp': timestamp,
    };
  }
}
