import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:technician_app/Assets/Model/order_model.dart';

const baseUrl = "http://82.112.238.13:5005";

class TechnicianJobOrder{
  Future<List<OrderModel>> getTechnicianJobs(
      String token, String technicianId, {String? status}) async {
    try {
      print('Fetching orders for technician ID: $technicianId with token: $token');

      // Build the URL correctly
      String url = '$baseUrl/dashboarddatabase/orders?technicianId=$technicianId';
      if (status != null && status != 'All') {
        url += '&status=$status'; // Correctly appending the status parameter
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token,
          'userType': 'technician'
        },
      ).timeout(const Duration(seconds: 10));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      print("Technician ID: $technicianId");

      if (response.statusCode == 200) {
        List<dynamic> ordersJson = jsonDecode(response.body)['result'];
        return ordersJson.map((json) => OrderModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch orders: ${response.reasonPhrase}');
      }
    } catch (error, stackTrace) {
      print('Error fetching orders: $error\n$stackTrace');
      throw Exception('Error fetching orders: $error');
    }
  }
}