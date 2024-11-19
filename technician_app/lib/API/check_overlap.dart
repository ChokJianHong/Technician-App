import 'dart:convert';
import 'package:http/http.dart' as http;

class CheckOverlap {
  static const String baseUrl =
      'http://82.112.238.13:5005'; // Replace with your backend URL

  // Function to check for job overlap
  static Future<Map<String, dynamic>> checkJobOverlap({
    required int technicianId,
    required String orderDate,
    required String orderTime,
  }) async {
    final url = Uri.parse(
        '$baseUrl/dashboarddatabase/technician/check-overlap/$technicianId');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'technician_id': technicianId,
          'order_date': orderDate,
          'order_time': orderTime,
        }),
      );

      // Print response for debugging
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to check job overlap: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error checking job overlap: $e');
    }
  }
}
