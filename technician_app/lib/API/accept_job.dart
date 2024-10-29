import 'dart:convert';
import 'package:http/http.dart' as http;

const baseUrl = "http://82.112.238.13:5005";

class AcceptJob {
  Future<void> acceptOrder(String token, int orderId, String eta, double totalAmount) async {
    final url = Uri.parse('$baseUrl/dashboarddatabase/orders/$orderId/accept');
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token,
        },
        body: jsonEncode({
          'eta': eta,
          'total_amount': totalAmount,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        // Order was accepted successfully
        print('Order accepted successfully.');
      } else {
        // Handle any other status codes
        print('Failed to accept order: ${response.reasonPhrase}');
        throw Exception('Failed to accept order: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error accepting order: $error');
      throw Exception('Error accepting order: $error');
    }
  }
}
