import 'package:flutter/material.dart';
import 'package:technician_app/core/configs/theme/app_colors.dart';

/* 

CURRENT SALES HOMEPAGE

Used for the amount of sales the technician made that month

-------------------------------------------------------------------------

*/

class CurrentSales extends StatelessWidget {
  const CurrentSales({super.key});

  @override
  Widget build(BuildContext context) {
    // Define text styles
    const TextStyle titleStyle = TextStyle(
        fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.words);

    const TextStyle subtitleStyle = TextStyle(
        fontWeight: FontWeight.w500, fontSize: 12, color: AppColors.grey);

    const TextStyle amountStyle = TextStyle(
        fontWeight: FontWeight.bold, fontSize: 40, color: AppColors.amount);

    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5), // Semi-transparent background
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
        padding: const EdgeInsets.all(16.0), // Padding inside the container
        child: const Column(
          mainAxisSize: MainAxisSize.min, // Minimize size to fit content
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Current Sales',
              style: titleStyle,
            ),
            Text(
              "For this month",
              style: subtitleStyle,
            ),
            SizedBox(height: 10),
            Text(
              "RM1000.00",
              style: amountStyle,
            ),
          ],
        ),
      ),
    );
  }
}
