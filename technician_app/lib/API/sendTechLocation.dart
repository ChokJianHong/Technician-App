import 'dart:convert';
import 'package:http/http.dart' as http;

const baseUrl = "http://10.0.2.2:5005";

class Sendtechlocation {
  Future<void> sendLocation(
      double longitude, double latitude, String token) async {
    final url = Uri.parse('$baseUrl/dashboarddatabase/technician/location');
    final headers = {
      'Content-Type': 'application/json',
      'Autorization': token,
    };
    final body = json.encode({
      'longitude': longitude,
      'latitude': latitude,
      'timestamp': DateTime.now().toIso8601String(),
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
    } catch (error) {
      print('Error accepting order: $error');
      throw Exception('Error accepting order: $error');
    }
  }
}
