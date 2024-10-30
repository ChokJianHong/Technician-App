// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:technician_app/core/configs/theme/appColors.dart';

class CategoryButtons extends StatefulWidget {
  final Function(String) onCategorySelected; // Callback for selected category

  const CategoryButtons({super.key, required this.onCategorySelected});

  @override
  _CategoryButtonsState createState() => _CategoryButtonsState();
}

class _CategoryButtonsState extends State<CategoryButtons> {
  String selectedCategory = ''; // Track the selected category

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: categoryButton(
            label: 'Alarm System',
            imagePath: 'lib/assets/images/Alarm.png',
            isSelected: selectedCategory == 'Alarm',
            onTap: () {
              setState(() {
                selectedCategory = 'Alarm'; // Set selected category
                widget.onCategorySelected(
                    selectedCategory); // Notify parent widget
              });
            },
          ),
        ),
        const SizedBox(width: 10), // Add space between buttons
        Expanded(
          child: categoryButton(
            label: 'AutoGate System',
            imagePath: 'lib/assets/images/Autogate.png',
            isSelected: selectedCategory == 'Autogate',
            onTap: () {
              setState(() {
                selectedCategory = 'Autogate'; // Set selected category
                widget.onCategorySelected(
                    selectedCategory); // Notify parent widget
              });
            },
          ),
        ),
      ],
    );
  }
}

// This is your category button with the animation
Widget categoryButton({
  required String label,
  required String imagePath,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300), // Animation duration
      curve: Curves.easeInOut, // Smooth animation curve
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.secondary : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: isSelected
            ? [const BoxShadow(color: AppColors.secondary, blurRadius: 10)]
            : [],
        border: Border.all(
          color: isSelected ? Colors.blueAccent : Colors.transparent,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize:
            MainAxisSize.min, // Ensures the button adjusts dynamically
        children: [
          Image.asset(imagePath, width: 50, height: 50),
          const SizedBox(height: 10),
          Text(
            label,
            textAlign: TextAlign.center, // Ensure text is centered
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}
