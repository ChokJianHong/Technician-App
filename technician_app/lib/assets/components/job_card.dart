import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

/* 

REUSABLE JOB CARD

A container that can store data in it

-------------------------------------------------------------------------

To use this widget, you need:

- `title` (required): A `String` representing the title of the job.
- `description` (required): A `String` representing the description of the job.

*/

class JobCard extends StatelessWidget {
  final String name;
  final String description;
  final String status;

  JobCard({
    required this.name,
    required this.description,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 100,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF4E31AA),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            name,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3795BD)),
            maxLines: 1,
          ),
          SizedBox(height: 10),
          AutoSizeText(
            '$description',
            style: TextStyle(fontSize: 12, color: Colors.white),
            maxLines: 3, // Adjust based on your layout
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 10),
          AutoSizeText(
            '$status',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
