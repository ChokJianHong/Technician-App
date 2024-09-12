import 'package:flutter/material.dart';
import '../components/job_card.dart';

/* 

CURRENT JOBS HOMEPAGE

Used for technician jobs

-------------------------------------------------------------------------

*/

class CurrentJobsSection extends StatelessWidget {
  final List<Map<String, String>> jobData;

  const CurrentJobsSection({super.key, required this.jobData});

  @override
  Widget build(BuildContext context) {
    // Create a list of JobCard widgets from jobData
    final jobCards = jobData.map((job) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: JobCard(
          name: job['name']!,
          description: job['description']!,
          status: job['status']!,
        ),
      );
    }).toList(); // Convert the Iterable to a List

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'Current Jobs',
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 150, // Height for the horizontal ListView of JobCard widgets
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), // Rounded corners
          ),
          child: ListView(
            scrollDirection: Axis.horizontal, // Horizontal scrolling
            shrinkWrap: true,
            children: jobCards, // Use the list of JobCard widgets here
          ),
        ),
      ],
    );
  }
}
