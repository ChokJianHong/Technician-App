import 'dart:convert';
import 'package:http/http.dart' as http;

class CancelService {
  static const String baseUrl = 'http://82.112.238.13:5005';


  static Future<Map<String, dynamic>> declineOrder(
      String orderId, String cancelDetails, String token) async {
    final url = Uri.parse('$baseUrl/dashboarddatabase/orders/$orderId/decline-request');

    print('Declining order from URL: $url'); // Print the URL

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token,
        'userType': 'technician', 
      },
      body: json.encode({
        'cancel_details': cancelDetails,
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
          'Failed to decline order. Status: ${response.statusCode}. Body: ${response.body}');
    }
  }
}
