import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:technician_app/core/configs/theme/appColors.dart';

class DelayedPaymentPage extends StatefulWidget {
  final String token;
  final String orderId;

  const DelayedPaymentPage({
    super.key,
    required this.token,
    required this.orderId,
  });

  @override
  State<DelayedPaymentPage> createState() => _DelayedPaymentPageState();
}

class _DelayedPaymentPageState extends State<DelayedPaymentPage> {
  DateTime? _selectedDate;
  final _signaturePadKey = GlobalKey<SignatureState>();
  final _signatureController = SignatureController();

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitDelayedPayment() async {
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a payment date.')),
      );
      return;
    }

    if (_signatureController.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide your signature.')),
      );
      return;
    }

    final signatureData = await _signatureController.toPngBytes();

    // Example API submission logic
    final paymentData = {
      "orderId": widget.orderId,
      "paymentDate": _selectedDate!.toIso8601String(),
      "signature": signatureData,
    };

    print("Payment Data: $paymentData");

    // Implement backend submission logic here

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Delayed Payment Submitted')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Delayed Payment'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select a Payment Date',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  _selectedDate == null
                      ? 'No date selected'
                      : _selectedDate!.toLocal().toString().split(' ')[0],
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: const Text('Pick Date'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Sign Below',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              height: 150,
              child: Signature(
                key: _signaturePadKey,
                controller: _signatureController,
                backgroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => _signatureController.clear(),
                  child: const Text('Clear Signature'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitDelayedPayment,
              child: const Text('Submit Delayed Payment'),
            ),
          ],
        ),
      ),
    );
  }
}
