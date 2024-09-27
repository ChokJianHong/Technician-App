import 'dart:convert';
import 'package:http/http.dart' as http;

const baseUrl = "http://10.0.2.2:5005";

class TechnicianToken{
  Future<Map<String, dynamic>> getTechnicianByToken(String token) async {
    final url = Uri.parse('$baseUrl/dashboarddatabase/technician/$token');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      print('Response code: ${response.statusCode}'); // Print response code
      print('Response body: ${response.body}'); // Print response body for debugging

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            'Failed to get customer details: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (error, stackTrace) {
      print('Error getting customer details: $error\n$stackTrace');
      throw Exception('Error getting customer details: $error');
    }
  }
}