import 'dart:convert';
import 'package:http/http.dart' as http;

class StatusTracking {
  static const String baseUrl = 'http://82.112.238.13:5005';

  // Function to update technician status based on order status
  static Future<void> updateTechnicianStatus(
      String technicianId, String orderId) async {
    final url = Uri.parse(
        '$baseUrl/dashboarddatabase/request/technician/$technicianId/$orderId');

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
        print("Response body: ${response.body}");
      } else {
        print(
            "Failed to update technician status. Status code: ${response.statusCode}");
        print("Response: ${response.body}");
        throw Exception("Failed to update technician status.");
      }
    } catch (error) {
      print("Error updating technician status: $error");
      rethrow;
    }
  }

  Future<void> updateOrderStatus(
      int orderId, String newStatus, String token) async {
    final url = Uri.parse('$baseUrl/dashboarddatabase/updateOrderStatus');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              token, // Assuming you're using an auth token
        },
        body: jsonEncode({
          'orderId': orderId,
          'newStatus': newStatus,
        }),
      );

      if (response.statusCode == 200) {
        print('Order status updated successfully: ${response.body}');
      } else {
        print('Failed to update order status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating order status: $error');
    }
  }
}
