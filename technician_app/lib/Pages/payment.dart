import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:technician_app/Assets/Components/button.dart';
import 'package:technician_app/Pages/home.dart';

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
  bool _showQrCode = false;

  @override
  void initState() {
    super.initState();
    // Automatically fetch payment details when the page loads
    calculatePayment(widget.orderId, widget.technicianId);
  }

  Future<void> _fetchDataAndNavigate(String orderId) async {
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
            'http://82.112.238.13:5005/dashboarddatabase/orders/$orderId/mark-complete'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': widget.token, // Ensure proper format
        },
      );

      // Close the loading dialog once the API response is received
      Navigator.of(context).pop();

      if (response.statusCode == 200) {
        // Decode the API response
        final data = json.decode(response.body);

        // Navigate to the home page and pass the fetched data
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              token: widget.token,
            ),
          ),
        );
      } else {
        // Handle non-200 responses
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to fetch data: ${response.statusCode}')),
        );
      }
    } catch (error) {
      // Close the loading dialog in case of an error
      Navigator.of(context).pop();

      // Handle network or parsing errors
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

    // Validate the orderId before making the request
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
        print('Error response: $errorData');
        setState(() {
          _paymentDetails = {'error': errorData['message'] ?? 'Unknown error'};
        });
      }
    } catch (e) {
      print('Connection error: $e');
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Payment Calculation',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Colors.teal,
              ),
            ),
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
                  : Card(
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
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  _showQrCode = true;
                                });
                              },
                              icon: const Icon(Icons.qr_code),
                              label: const Text('Show QR Code'),
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
                          ],
                        ),
                      ),
                    ),
            MyButton(
                text: 'Completed Payment',
                onTap: () {
                  _fetchDataAndNavigate(widget.orderId);
                })
          ],
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
