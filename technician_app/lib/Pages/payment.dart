import 'package:flutter/material.dart';
import 'package:technician_app/Assets/Components/category.dart';
import 'package:technician_app/Assets/Components/text_box.dart';
import 'package:technician_app/core/configs/theme/appColors.dart';

class Payment extends StatefulWidget {
  final String token;

  Payment({super.key, required this.token});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final TextEditingController _newsearchController = TextEditingController();
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              'Payment:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            MyTextField(
              controller: _newsearchController,
              hintText: 'Amount',
              obscureText: false,
            ),
            const SizedBox(height: 20),
            CategoryButtons(
              onCategorySelected: (category) {
                setState(() {
                  selectedCategory = category;
                });
              },
            ),
            if (selectedCategory != null)
              Text(
                'Selected Category: $selectedCategory',
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.primary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
