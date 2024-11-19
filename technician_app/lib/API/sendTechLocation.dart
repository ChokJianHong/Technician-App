import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const baseUrl = "http://82.112.238.13:5005";

class Sendtechlocation {
  Future<void> sendLocation(String technicianId, double longitude,
      double latitude, String token) async {
    final url = Uri.parse(
        '$baseUrl/dashboarddatabase/technician/location/$technicianId'); // Add technicianId to the URL
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };
    final body = json.encode({
      'longitude': longitude, // Fixed: longitude should be mapped to longitude
      'latitude': latitude, // Fixed: latitude should be mapped to latitude
    });

    try {
      final response = await http.put(url, headers: headers, body: body);
      if (response.statusCode != 200) {
        print('Failed to send location: ${response.statusCode}');
        throw Exception('Failed to send location');
      } else {
        print('Location sent successfully');
      }
    } catch (error) {
      print('Error sending location: $error');
      throw Exception('Error sending location: $error');
    }
  }

  Future<void> changeStatus({
    required String technicianId,
    required String orderId,
    required String token,
    required String status,
  }) async {
    final url = Uri.parse(
        'http://82.112.238.13:5005/dashboarddatabase/technician/status/$technicianId');

    // Prepare the request body
    final body = {
      'technicianId': technicianId,
      'orderId': orderId,
      'status': status,
    };

    try {
      // Make the POST request
      final response = await http.put(
        url,
        headers: {
          'Authorization': token,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update order status: ${response.body}');
      }

      debugPrint("Order status updated successfully for orderId: $orderId");
    } catch (e) {
      debugPrint("Error updating order status: $e");
      throw Exception("Error updating order status.");
    }
  }
}
