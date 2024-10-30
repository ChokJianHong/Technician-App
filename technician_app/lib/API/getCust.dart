import 'dart:convert'; // For json decoding
import 'package:http/http.dart' as http;

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
