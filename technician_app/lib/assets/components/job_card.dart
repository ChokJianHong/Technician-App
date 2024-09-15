import 'package:flutter/material.dart';

/* 

REUSABLE JOB CARD

A container that can store data in it

-------------------------------------------------------------------------

To use this widget, you need:

- `title` (required): A `String` representing the title of the job.
- `description` (required): A `String` representing the description of the job.

*/

class JobCard extends StatelessWidget {
  final String title;
  final String description;

  const JobCard({super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16.0), // Add padding to ListTile
        title: Text(title),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          // Handle job tap here
        },
      ),
    );
  }
}
