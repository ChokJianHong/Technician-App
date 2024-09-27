import 'dart:convert';
import 'dart:async'; // For handling timeouts
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

const baseUrl = "http://10.0.2.2:5005"; // Adjust if needed

class SignInAPI {
  final storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/dashboarddatabase/login'),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
            },
            // Encode the body so that the program recognizes it is a JSON file
            body: jsonEncode({
              'email': email,
              'password': password,
              'userType': 'technician',
            }),
          )
          .timeout(const Duration(seconds: 20)); // Add a timeout of 10 seconds

      if (response.statusCode == 200) {
        // Parse the JSON response body to a Dart object
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to register user: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error registering user: $error');
    }
  }
}
