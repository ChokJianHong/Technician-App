import 'dart:convert';
import 'package:http/http.dart' as http;

class CalendarDataSource {
  final String apiUrl =
      'http://localhost:5005/calendar'; // Update with your backend URL

  Future<List<Map<String, dynamic>>> getEventsForDay(DateTime day) async {
    final response = await http.get(
      Uri.parse('$apiUrl/get-events/${day.toIso8601String()}'),
    );
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to get events for day');
    }
  }

  Future<Map<String, dynamic>> createEvent(Map<String, dynamic> event) async {
    final response = await http.post(
      Uri.parse('$apiUrl/create-event'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(event),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create event');
    }
  }

  Future<void> deleteEvent(String eventId) async {
    final response = await http.delete(
      Uri.parse('$apiUrl/delete-event/$eventId'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete event');
    }
  }
}
