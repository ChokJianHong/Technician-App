import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

// Reusable Job Card Widget
class JobCard extends StatelessWidget {
  final String name;
  final String description;
  final String status;

  const JobCard({
    super.key,
    required this.name,
    required this.description,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    // Define a status color based on the status text
    Color statusColor;
    switch (status.toLowerCase()) {
      case 'completed':
        statusColor = Colors.green;
        break;
      case 'in progress':
        statusColor = Colors.orange;
        break;
      case 'pending':
      default:
        statusColor = Colors.red;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            name,
            maxLines: 1,
          ),
          const SizedBox(height: 8),
          AutoSizeText(
            description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatusBadge(status: status, color: statusColor),
            ],
          ),
        ],
      ),
    );
  }
}

// Custom widget for displaying status with a badge
class _StatusBadge extends StatelessWidget {
  final String status;
  final Color color;

  const _StatusBadge({
    required this.status,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: AutoSizeText(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
        maxLines: 1,
      ),
    );
  }
}
