import 'dart:convert';
import 'package:http/http.dart' as http;

class RequestPartService {
  static const String baseUrl = 'http://82.112.238.13:5005';

  /// Fetch request forms by `orderId`
  static Future<List<Map<String, dynamic>>> getRequestFormsByOrderId(
      String orderId, String token) async {
    final url = Uri.parse('$baseUrl/dashboarddatabase/technician/request_part/$orderId');

    print('Fetching request forms from URL: $url'); // Debugging log

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token,
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.cast<Map<String, dynamic>>();
    } else if (response.statusCode == 404) {
      print('No request forms found for order ID: $orderId');
      return [];
    } else {
      throw Exception(
          'Failed to fetch request forms. Status: ${response.statusCode}, Body: ${response.body}');
    }
  }
}
