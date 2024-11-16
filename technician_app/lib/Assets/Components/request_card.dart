import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:technician_app/API/getTechnician.dart';
import 'package:technician_app/API/get_request_form.dart';
import 'package:technician_app/Assets/Components/currentJobCard.dart';
import 'dart:async';

class RequestCard extends StatefulWidget {
  final String token;

  const RequestCard({super.key, required this.token});

  @override
  State<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  late Future<List<Map<String, dynamic>>> _partRequestsFuture;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _partRequestsFuture = _fetchPartRequests();

    // Periodic refresh every 30 seconds
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      setState(() {
        _partRequestsFuture = _fetchPartRequests();
      });
    });
  }

  Future<List<Map<String, dynamic>>> _fetchPartRequests() async {
    try {
      // Decode the technician ID from the token
      String technicianId;
      Map<String, dynamic> decodedToken = JwtDecoder.decode(widget.token);
      technicianId = decodedToken['userId'].toString();

      // Fetch technician details
      Map<String, dynamic> technicianDetails =
          await TechnicianService.getTechnician(widget.token, technicianId);

      if (technicianDetails['technician'] != null &&
          technicianDetails['technician'].isNotEmpty) {
        String technicianName = technicianDetails['technician'][0]['name'];

        // Fetch part requests by technician name
        return await RequestFormService.getRequestFormsByTechnician(
            technicianName, widget.token);
      } else {
        throw Exception("Technician details are empty or missing.");
      }
    } catch (error) {
      print("Error fetching part requests: $error");
      return [];
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _partRequestsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error fetching part requests: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else if (snapshot.hasData) {
          final List<Map<String, dynamic>> partRequests = snapshot.data!;

          if (partRequests.isEmpty) {
            return const Center(
              child: Text(
                'No part requests available.',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            );
          }

          return SizedBox(
            height: 300,
            child: ListView.builder(
              itemCount: partRequests.length,
              itemBuilder: (context, index) {
                final partRequest = partRequests[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: GestureDetector(
                    onTap: () {
                      // Handle part request tap if needed
                    },
                    child: JobCard(
                      name: partRequest['equipment'] ?? 'Unknown Equipment',
                      description:
                          'Brand: ${partRequest['brand']}, Parts needed: ${partRequest['parts_needed']}',
                      status: partRequest['status'] ?? 'Pending',
                    ),
                  ),
                );
              },
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
