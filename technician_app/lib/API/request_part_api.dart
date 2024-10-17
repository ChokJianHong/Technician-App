import 'dart:convert';
import 'package:http/http.dart' as http;


class RequestService {
  final String baseUrl = 'http://localhost:3000'; // Adjust this for your server's URL

  Future<void> createRequestForm({
    required String technicianName,
    required String customerName,
    required String equipment,
    required String brand,
    required String partsNeeded,
  }) async {
    final url = Uri.parse('$baseUrl/request');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'technician_name': technicianName,
          'customer_name': customerName,
          'equipment': equipment,
          'brand': brand,
          'parts_needed': partsNeeded,
        }),
      );

      if (response.statusCode == 201) {
        final responseBody = json.decode(response.body);
        print("Request Form submitted! ID: ${responseBody['id']}");
      } else {
        final errorBody = json.decode(response.body);
        throw Exception('Failed to submit request: ${errorBody['message']}');
      }
    } catch (error) {
      print("Error: $error");
      throw Exception("Failed to submit request form.");
    }
  }
}
