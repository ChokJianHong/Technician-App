import 'dart:convert';
import 'package:http/http.dart' as http;

const baseUrl = "http://82.112.238.13:5005";

class Req {
  Future<Map<String, dynamic>> getCustomerDetails(String customerId) async {
    final String apiUrl =
        'http://82.112.238.13:5005/dashboarddatabase/technician/customersDetail/$customerId'; // Replace with your API endpoint

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Parse the JSON response
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['status'] == 200) {
          // Success
          return responseData['data'];
        } else {
          // Handle API-specific errors
          throw Exception('Error: ${responseData['message']}');
        }
      } else if (response.statusCode == 404) {
        throw Exception('Customer not found');
      } else {
        // Handle other unexpected status codes
        throw Exception(
            'Failed to load customer details: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network errors or other issues
      throw Exception('Error fetching customer details: $error');
    }
  }

  Future<void> createRequestForm({
    required String technicianName,
    required String customerId,
    required String customerName,
    required String equipment,
    required String brand,
    required String partsNeeded,
    required int orderId,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/dashboarddatabase/request');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'customerId': customerId,
          'technician_name': technicianName,
          'customer_name': customerName,
          'equipment': equipment,
          'brand': brand,
          'parts_needed': partsNeeded,
          'order_id': orderId,
        }),
      );

      print('Response code: ${response.statusCode}'); // Print response code
      print(
          'Response body: ${response.body}'); // Print response body for debugging

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
