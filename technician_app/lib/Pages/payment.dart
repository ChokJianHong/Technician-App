import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:technician_app/Assets/Components/text_box.dart';
import 'package:http/http.dart' as http;

class Payment extends StatefulWidget {
  final String token;
  final String orderId;

  const Payment({super.key, required this.token, required this.orderId});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  final TextEditingController _orderIdController = TextEditingController();
  Map<String, dynamic>? _paymentDetails;
  bool _loading = false;
  bool _showQrCode = false;

  Future<void> fetchPaymentDetails(String orderId) async {
    setState(() {
      _loading = true;
      _paymentDetails = null;
    });

    try {
      final response = await http.post(
        Uri.parse(
            'http://82.112.238.13:5005/dashboarddatabase/calculate-payment'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': widget.token,
        },
        body: jsonEncode({'orderId': int.parse(orderId)}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Response data: $data'); // Debugging: Log the backend response
        setState(() {
          _paymentDetails =
              data['paymentDetails']; // Expecting a `paymentDetails` key
        });
      } else {
        final errorData = jsonDecode(response.body);
        print(
            'Error response: $errorData'); // Debugging: Log the error response
        setState(() {
          _paymentDetails = {'error': errorData['message'] ?? 'Unknown error'};
        });
      }
    } catch (e) {
      print('Connection error: $e'); // Debugging: Log connection issues
      setState(() {
        _paymentDetails = {'error': 'Error connecting to server'};
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Payment Calculation',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            MyTextField(
              controller: _orderIdController,
              hintText: 'Enter Order ID',
              obscureText: false,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading
                  ? null
                  : () => fetchPaymentDetails(_orderIdController.text),
              child: _loading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text('Fetch Payment Details'),
            ),
            const SizedBox(height: 20),
            if (_paymentDetails != null)
              _paymentDetails!['error'] != null
                  ? Text(
                      _paymentDetails!['error'],
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order ID: ${_paymentDetails!['order_id']}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Technician ID: ${_paymentDetails!['technician_id']}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Total Hours: ${_paymentDetails!['total_hours']}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Spare Part Cost: RM ${_paymentDetails!['spare_part_cost']}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Total Amount: RM ${_paymentDetails!['total_amount']}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _showQrCode = true;
                            });
                          },
                          child: const Text('Show QR Code'),
                        ),
                        const SizedBox(height: 20),
                        if (_showQrCode)
                          Column(
                            children: [
                              const Text(
                                'Scan the QR code below to complete the payment:',
                                style: TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 20),
                              Image.asset(
                                'lib/Assets/Images/duitnow.jpg', // Path to your pre-stored QR image
                                width: 200,
                                height: 200,
                              ),
                            ],
                          ),
                      ],
                    ),
          ],
        ),
      ),
    );
  }
}
