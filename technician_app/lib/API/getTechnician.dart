// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl =
    "http://10.0.2.2:5005"; // Update this with your actual backend URL

class TechnicianService {
  // Method to get technician by ID
  Future<Map<String, dynamic>> getTechnicianById(
      String token, String technicianId) async {
    final url =
        Uri.parse('$baseUrl/dashboarddatabase/admin/technician/$technicianId');

    // Send a GET request to the API
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
        },
      );

      // Check the response status
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Check for a successful status
        if (responseData['status'] == 200) {
          // Success, return technician details
          return responseData['technician']; // Return technician details
        } else {
          // Handle API-specific errors
          throw Exception('Error: ${responseData['message']}');
        }
      } else if (response.statusCode == 404) {
        throw Exception('Technician not found');
      } else {
        // Handle other unexpected status codes
        throw Exception('Failed to load technician: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network errors or other issues
      throw Exception('Error fetching technician details: $error');
    }
  }
}
