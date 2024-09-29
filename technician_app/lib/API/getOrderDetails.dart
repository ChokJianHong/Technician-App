import 'dart:convert';
import 'package:http/http.dart' as http;

const baseUrl = "http://10.0.2.2:5005";

class OrderDetails{
  Future<Map<String, dynamic>> getOrderDetail(String token, String orderId) async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/dashboarddatabase/orders/details/$orderId'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token,
      },
    );
    
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {'success': true, 'result': data['result']};
    } else if (response.statusCode == 404) {
      return {'success': false, 'error': 'Order not found'};
    } else {
      return {'success': false, 'error': 'Failed to load order details'};
    }
  } catch (error) {
    print('Error fetching order details: $error');
    return {'success': false, 'error': 'Error fetching order details: $error'};
  }
}
}