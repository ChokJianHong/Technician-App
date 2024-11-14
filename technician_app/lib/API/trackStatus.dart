import 'dart:convert';
import 'package:http/http.dart' as http;

class StatusTracking {
  static const String baseUrl =
      'http://10.0.2.2:5005'; // Replace with your backend URL

  // Function to update technician status based on order status
  static Future<void> updateTechnicianStatus(
      String technicianId, String orderId) async {
    final url = Uri.parse(
        '$baseUrl/dashboarddatabase/request/technician/$technicianId');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'orderId': orderId}),
      );

      if (response.statusCode == 200) {
        print("Technician status updated successfully.");
      } else {
        print(
            "Failed to update technician status. Status code: ${response.statusCode}");
        print("Response: ${response.body}");
        throw Exception("Failed to update technician status.");
      }
    } catch (error) {
      print("Error updating technician status: $error");
      throw error;
    }
  }
}
