import 'dart:convert';
import 'package:http/http.dart' as http;

class RequestFormService {
  static const String baseUrl = 'http://82.112.238.13:5005';

  static Future<List<Map<String, dynamic>>> getRequestFormsByTechnician(
      String technicianName, String token) async {
    // Build the URI with the technician name parameter
    final url = Uri.parse('$baseUrl/dashboarddatabase/request/technician/$technicianName');

    print('Fetching request forms from URL: $url'); // For debugging

    // Send a GET request with headers including authorization
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token,
      },
    );

    // Print the response status and body for debugging
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    // Handle the response based on status code
    if (response.statusCode == 200) {
      List<dynamic> responseBody = json.decode(response.body);
      return responseBody.cast<Map<String, dynamic>>(); // Convert JSON list to List of Maps
    } else if (response.statusCode == 404) {
      throw Exception('No request forms found for this technician.');
    } else {
      throw Exception(
          'Failed to retrieve request forms. Status: ${response.statusCode}. Body: ${response.body}');
    }
  }
}
