import 'package:flutter/material.dart';
import 'package:technician_app/common/widgets/newjobCard/new_jobcard.dart';

class NewJobsSection extends StatelessWidget {
  final List<Map<String, String>> newjobData;

  const NewJobsSection({super.key, required this.newjobData});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double cardWidth = constraints.maxWidth * 0.8;
        const double cardHeight = 180;

        final jobCards = newjobData.map((newJob) {
          return Padding(
            padding:
                EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.02),
            child: SizedBox(
              width: cardWidth,
              child: NewJobcard(
                name: newJob['name']!,
                location: newJob['location']!,
                jobType: newJob['jobtype']!,
                status: newJob['status']!,
              ),
            ),
          );
        }).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'New Jobs',
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: cardHeight,
              child: ListView(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(
                    horizontal: constraints.maxWidth * 0.02),
                children: jobCards,
              ),
            ),
          ],
        );
      },
    );
  }
}
