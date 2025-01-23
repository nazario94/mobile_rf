import 'package:flutter/services.dart';
import 'dart:convert';

// class CellInfoChannel {
//   static const MethodChannel _channel = MethodChannel('cell_info');
//
//   static Future<Map<String, dynamic>?> getCellInfo() async {
//     try {
//       final result = await _channel.invokeMethod('getCellInfo');
//       final parsedResult = jsonDecode(result) as Map<String, dynamic>;
//       return Map<String, dynamic>.from(parsedResult);
//     } catch (e) {
//       print("Error retrieving cell info: $e");
//       return null;
//     }
//   }
// }
// import 'dart:convert';
// import 'package:flutter/services.dart';

class CellInfoChannel {
  static const MethodChannel _channel = MethodChannel('cell_info');

  static Future<List<Map<String, dynamic>>> getCellInfo() async {
    try {
      final result = await _channel.invokeMethod('getCellInfo');
      if (result is String) {
        List<dynamic> parsed = jsonDecode(result);
        return parsed.map((e) => Map<String, dynamic>.from(e)).toList();
      }
      return [];
    } catch (e) {
      print("Error retrieving cell info: $e");
      return [];
    }
  }
}
