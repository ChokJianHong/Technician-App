import 'package:flutter/material.dart';
import 'package:technician_app/common/widgets/currentjobCard/current_jobcard.dart';


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
    return LayoutBuilder(
      builder: (context, constraints) {
        final double cardWidth = constraints.maxWidth *
            0.7; // Adjust card width relative to available width
        const double cardHeight = 180; // Fixed height for cards

        // Create a list of JobCard widgets from jobData
        final jobCards = jobData.map((job) {
          return Padding(
            padding: EdgeInsets.symmetric(
                horizontal: constraints.maxWidth *
                    0.02), // Responsive horizontal padding
            child: SizedBox(
              width: cardWidth,
              child: JobCard(
                name: job['name']!,
                description: job['description']!,
                status: job['status']!,
              ),
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
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height:
                  cardHeight, // Height for the horizontal ListView of JobCard widgets
              child: ListView(
                scrollDirection: Axis.horizontal, // Horizontal scrolling
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(
                    horizontal: constraints.maxWidth *
                        0.02), // Responsive horizontal padding
                children: jobCards, // Use the list of JobCard widgets here
              ),
            ),
          ],
        );
      },
    );
  }
}
