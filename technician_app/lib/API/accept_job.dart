import 'dart:convert';
import 'package:http/http.dart' as http;

const baseUrl = "http://10.0.2.2:5005"; // Base URL for the API

class OrderService {
  Future<Map<String, dynamic>> assignTechnician(
    String token,
    String orderId,
    String technicianId,
  ) async {
    final url = Uri.parse('$baseUrl/orders/$orderId/assign-technician');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':  token, 
        },
        body: jsonEncode({'technician_id': technicianId}), // Send technician_id in body
      ).timeout(const Duration(seconds: 10));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Return response data as a Map
      } else {
        throw Exception('Failed to assign technician: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error assigning technician: $error');
      throw Exception('Error assigning technician: $error');
    }
  }
}
