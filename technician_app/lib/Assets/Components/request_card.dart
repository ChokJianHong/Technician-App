import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:technician_app/API/getTechnician.dart';
import 'package:technician_app/API/get_request_form.dart';
import 'package:technician_app/Assets/Components/currentJobCard.dart';

class RequestCard extends StatefulWidget {
  final String token;
  const RequestCard({super.key, required this.token});

  @override
  State<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  String technicianName = "Loading...";
  List<Map<String, dynamic>> requestForms = [];

  @override
  void initState() {
    super.initState();
    String technicianId;
    try {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(widget.token);
      technicianId = decodedToken['userId'].toString();
      print('Technician ID: $technicianId');
    } catch (error) {
      print('Error decoding token: $error');
      technicianId = 'default';
    }
    _fetchTechnicianName(technicianId);
  }

  void _fetchTechnicianName(String technicianId) async {
    try {
      Map<String, dynamic> technicianDetails =
          await TechnicianService.getTechnician(widget.token, technicianId);

      if (technicianDetails['technician'] != null &&
          technicianDetails['technician'].isNotEmpty) {
        String name = technicianDetails['technician'][0]['name'];
        setState(() {
          technicianName = name;
        });
        _fetchRequestForms(
            name); // Fetch request forms based on technician name
      } else {
        throw Exception("Technician details are empty or missing.");
      }
    } catch (error) {
      print("Error fetching technician details: $error");
      setState(() {
        technicianName = "Unknown";
      });
    }
  }

  void _fetchRequestForms(String technicianName) async {
    try {
      List<Map<String, dynamic>> fetchedForms =
          await RequestFormService.getRequestFormsByTechnician(
              technicianName, widget.token);
      setState(() {
        requestForms = fetchedForms;
      });
    } catch (error) {
      print("Error fetching request forms: $error");
      setState(() {
        requestForms = []; // Clear list on error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Display request forms or a message if none are found
        requestForms.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: requestForms.length,
                itemBuilder: (context, index) {
                  final form = requestForms[index];
                  return JobCard(
                    name: form['equipment'] ?? 'Unknown Equipment',
                    description:
                        'Brand: ${form['brand']}, Parts needed: ${form['parts_needed']}',
                    status: form['status'] ?? 'Pending',
                  );
                },
              )
            : const Text(
                'No part requests available.',
                style: TextStyle(color: Colors.white),
              ),
      ],
    );
  }
}
