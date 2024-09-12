import 'package:flutter/material.dart';

/* 

CURRENT SALES HOMEPAGE

Used for the amount of sales the technician made that month

-------------------------------------------------------------------------

*/

class CurrentSales extends StatelessWidget {
  const CurrentSales({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        children: [
          Text(
            'Current Sales',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
          ),
          Text(
            "Since the 1st of the month",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "RM1000.00",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
