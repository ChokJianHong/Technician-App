import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:technician_app/Assets/Model/order_model.dart';

const baseUrl = "http://10.0.2.2:5005";

class OrderService {
  Future<List<OrderModel>> getPendingOrders(String token) async {
    final url =
        Uri.parse('$baseUrl/dashboarddatabase/orders/pending?status=pending');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token,
        },
      ).timeout(const Duration(seconds: 10));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Parse the response and convert to a list of OrderModel objects
        List<dynamic> data = jsonDecode(response.body)['result'];

        // No filtering for technician_id, map all orders directly to OrderModel
        List<OrderModel> pendingOrders =
            data.map((order) => OrderModel.fromJson(order)).toList();

        return pendingOrders;
      } else {
        throw Exception(
            'Failed to load pending orders: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error fetching pending orders: $error');
      throw Exception('Error fetching pending orders: $error');
    }
  }
}
