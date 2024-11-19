import 'dart:convert';
import 'package:http/http.dart' as http;

const baseUrl = "http://82.112.238.13:5005";
class ReviewApi {
  

  Future<Map<String, dynamic>> createReview({
    required String token,
    required String orderId,
    required int rating,
    required String reviewText,
  }) async {
    final url = Uri.parse('$baseUrl/dashboarddatabase/orders/review/$orderId');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token, 
        },
        body: jsonEncode({
          'rating': rating,
          'reviewText': reviewText,
        }),
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': jsonDecode(response.body)['message'],
        };
      } else {
        return {
          'success': false,
          'message': jsonDecode(response.body)['message'],
        };
      }
    } catch (error) {
      return {
        'success': false,
        'message': 'Error: $error',
      };
    }
  }
}
