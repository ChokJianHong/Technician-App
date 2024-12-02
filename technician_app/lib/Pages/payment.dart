import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:technician_app/Assets/Components/button.dart';
import 'package:technician_app/Pages/delayed_payment.dart';
import 'package:technician_app/Pages/home.dart';
import 'package:technician_app/core/configs/theme/appColors.dart';

class Payment extends StatefulWidget {
  final String token;
  final String orderId;
  final String technicianId;

  const Payment(
      {super.key,
      required this.token,
      required this.orderId,
      required this.technicianId});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  Map<String, dynamic>? _paymentDetails;
  bool _loading = false;
  String _paymentMethod = "cash"; // Default payment method
  bool _showQrCode = false;

  @override
  void initState() {
    super.initState();
    // Automatically fetch payment details when the page loads
    calculatePayment(widget.orderId, widget.technicianId);
  }

  Future<void> _sendDatatoOrder(String orderId, String paymentMethod) async {
    try {
      final response = await http.put(
        Uri.parse(
            'http://82.112.238.13:5005/dashboarddatabase/complete-payment'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': widget.token,
        },
        body: json.encode({
          'order_id': orderId,
          'price_details': paymentMethod,
        }),
      );

      if (response.statusCode == 200) {
        // Successfully updated the order
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment method updated successfully!')),
        );
      } else {
        // Handle server error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update payment: ${response.body}')),
        );
      }
    } catch (e) {
      // Handle network or unexpected error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating payment: $e')),
      );
    }
  }

  Future<void> _fetchDataAndNavigate(
      String orderId, String technicianId) async {
    try {
      // Display a loading indicator while the API request is in progress
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      // Fetch data from the backend API
      final response = await http.put(
        Uri.parse(
            'http://82.112.238.13:5005/dashboarddatabase/orders/$orderId/mark-complete/$technicianId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': widget.token,
        },
      );

      // Close the loading dialog once the API response is received
      Navigator.of(context).pop();

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              token: widget.token,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to fetch data: ${response.statusCode}')),
        );
      }
    } catch (error) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $error')),
      );
    }
  }

  Future<void> calculatePayment(String orderId, String technicianId) async {
    setState(() {
      _loading = true;
      _paymentDetails = null;
    });

    if (orderId.isEmpty || int.tryParse(orderId) == null) {
      setState(() {
        _loading = false;
        _paymentDetails = {'error': 'Invalid order ID'};
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(
            'http://82.112.238.13:5005/dashboarddatabase/calculate-payment/$orderId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: jsonEncode({
          'orderId': orderId,
          'technicianId': technicianId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _paymentDetails = data;
        });
      } else {
        final errorData = jsonDecode(response.body);
        setState(() {
          _paymentDetails = {'error': errorData['message'] ?? 'Unknown error'};
        });
      }
    } catch (e) {
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
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      backgroundColor: AppColors.primary,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            if (_loading)
              const Center(child: CircularProgressIndicator())
            else if (_paymentDetails != null)
              _paymentDetails!['error'] != null
                  ? Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _paymentDetails!['error'],
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : Column(children: [
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildDetailRow('Order ID', widget.orderId),
                              buildDetailRow(
                                  'Technician ID', widget.technicianId),
                              buildDetailRow(
                                'Total Hours',
                                _paymentDetails!['totalHours'] != null
                                    ? '${double.parse(_paymentDetails!['totalHours'].toString()).toStringAsFixed(2)} hrs'
                                    : 'N/A',
                              ),
                              buildDetailRow(
                                'Spare Part Cost',
                                _paymentDetails!['totalSparePartCost'] != null
                                    ? 'RM ${double.parse(_paymentDetails!['totalSparePartCost'].toString()).toStringAsFixed(2)}'
                                    : 'N/A',
                              ),
                              buildDetailRow(
                                'Total Amount',
                                _paymentDetails!['totalAmount'] != null
                                    ? 'RM ${double.parse(_paymentDetails!['totalAmount'].toString()).toStringAsFixed(2)}'
                                    : 'N/A',
                                isBold: true,
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildToggleButton("Cash", "cash"),
                                  const SizedBox(width: 10),
                                  _buildToggleButton("QR Code", "qr"),
                                ],
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
                                    Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      elevation: 4,
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Image.asset(
                                          'lib/Assets/Images/duitnow.jpg',
                                          width: 200,
                                          height: 200,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              const SizedBox(height: 20),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DelayedPaymentPage(
                                        token: widget.token,
                                        orderId: widget.orderId,
                                      ),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Customer cannot pay now? Set up delayed payment.',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
            const SizedBox(height: 20),
            MyButton(
              text: 'Complete Payment',
              onTap: () async {
                // Confirm the user wants to complete the payment
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Confirm Payment'),
                    content: Text(
                        'Are you sure you want to complete the payment using $_paymentMethod?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Confirm'),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  try {
                    // Step 1: Send the payment method data to the backend
                    await _sendDatatoOrder(widget.orderId, _paymentMethod);

                    // Step 2: Mark the order as complete and navigate
                    await _fetchDataAndNavigate(
                        widget.orderId, widget.technicianId);

                    // Optionally, show a success message (only if both succeed)
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Payment completed successfully!')),
                    );
                  } catch (e) {
                    // Handle any errors that occur during the process
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error completing payment: $e')),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton(String label, String value) {
    final bool isSelected = _paymentMethod == value;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300), // Smooth animation
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isSelected ? Colors.teal : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? Colors.teal : Colors.grey,
          width: 2,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: Colors.teal.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            setState(() {
              _paymentMethod = value;
              _showQrCode = value == "qr";
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDetailRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              color: Colors.black87,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
