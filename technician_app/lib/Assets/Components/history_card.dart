import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:technician_app/core/configs/theme/appColors.dart';


class NewJobcard extends StatelessWidget {
  final String name;
  final String location;
  final String jobType;
  final String status;

  const NewJobcard({
    super.key,
    required this.name,
    required this.location,
    required this.jobType,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final jobTypeColor = _getJobColor(jobType);
    final statusColor = _getJobColor(status);

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.secondary,
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
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.grey,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          AutoSizeText(
            location,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _JobType(color: jobTypeColor, jobType: jobType),
              const SizedBox(width: 8),
              _Statustype(color: statusColor, statusType: status),
            ],
          ),
        ],
      ),
    );
  }

  Color _getJobColor(String type) {
    switch (type.toLowerCase()) {
      case 'alarm':
        return const Color.fromARGB(255, 193, 196, 55);
      case 'emergency':
        return Colors.red;
      case 'normal':
        return Colors.orange;
      case 'urgent':
        return Colors.orange;
      default:
        return const Color.fromARGB(255, 54, 130, 244);
    }
  }
}

class _JobType extends StatelessWidget {
  final String jobType;
  final Color color;

  const _JobType({required this.color, required this.jobType});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: AutoSizeText(
        jobType,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}

class _Statustype extends StatelessWidget {
  final String statusType;
  final Color color;

  const _Statustype({required this.color, required this.statusType});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: AutoSizeText(
        statusType,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
