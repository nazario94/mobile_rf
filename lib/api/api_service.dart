import 'package:http/http.dart' as http;
import 'dart:convert';


class APIService {
  static Future<void> sendData(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8001/collect-data/'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      print("Data sent successfully");
    } else {
      print("Failed to send data");
    }
  }

}
