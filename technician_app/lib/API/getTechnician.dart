import 'dart:convert';
import 'package:http/http.dart' as http;

class TechnicianService {
  static const String baseUrl =
      'http://10.0.2.2:5005'; 

  static Future<Map<String, dynamic>> getTechnician(
      String token, String technicianId) async {
    final url =
        Uri.parse('$baseUrl/dashboarddatabase/admin/technicians/$technicianId');

    print('Fetching technician from URL: $url'); // Print the URL

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token,
        'userType': 'technician',
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
          'Failed to load technician. Status: ${response.statusCode}. Body: ${response.body}');
    }
  }
}
