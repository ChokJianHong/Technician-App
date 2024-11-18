import 'dart:convert';
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
      'longitude': latitude,
      'latitude': longitude,
    });

    try {
      final response = await http.put(url, headers: headers, body: body);
      print(response);
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

  Future<void> sendTime(
      String orderid, String token, String currentTime) async {
    final url = Uri.parse(
        'http://10.2.2.2:5005/dashboarddatabase/technician/arrive/$orderid'); // Add technicianId to the URL
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };
    final body = json.encode({
      'start_time': currentTime,
    });

    try {
      final response = await http.put(url, headers: headers, body: body);
      print(response);
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

  Future<void> changeStatus(
      String technicianId, String token,String status, ) async {
    final url = Uri.parse(
        'http://82.112.238.13:5005/dashboarddatabase/technician/status/$technicianId');
    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
          'userType': 'technician',
        },
        body: jsonEncode({'status': status}),
      );

      if (response.statusCode == 200) {
        print('Status updated successfully');
      } else {
        throw Exception('Failed to update status: ${response.body}');
      }
    } catch (e) {
      print('Error changing status: $e');
    }
  }
}
