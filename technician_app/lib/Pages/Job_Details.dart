// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:technician_app/API/getOrderDetails.dart';
import 'package:technician_app/Assets/Components/AppBar.dart';
import 'package:technician_app/Pages/part_request.dart';
import 'package:technician_app/assets/components/BottomNav.dart';
import 'package:technician_app/assets/components/button.dart';
import 'package:technician_app/core/configs/theme/appColors.dart';

class RequestDetails extends StatefulWidget {
  final String token;
  final String orderId;

  const RequestDetails({super.key, required this.token, required this.orderId});

  @override
  State<RequestDetails> createState() => _RequestDetailsState();
}

class _RequestDetailsState extends State<RequestDetails> {
  int _currentIndex = 2;
  late Future<Map<String, dynamic>> _orderDetailFuture;

  void _onTapTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _orderDetailFuture = _fetchOrderDetails(widget.token, widget.orderId);
  }

  String formatDateTime(String utcDateTime) {
    try {
      // Parse the UTC date string into a DateTime object
      DateTime parsedDate = DateTime.parse(utcDateTime);

      // Convert the UTC date to local time
      DateTime localDate = parsedDate.toLocal();

      // Format the local date into a desired string format
      return DateFormat('yyyy-MM-dd HH:mm:ss')
          .format(localDate); // Adjust format as needed
    } catch (e) {
      // Handle potential parsing errors
      print('Error parsing date: $e');
      return 'Invalid date'; // Return a default value or error message
    }
  }

  Future<Map<String, dynamic>> _fetchOrderDetails(
      String token, String orderId) async {
    try {
      final orderDetails = await OrderDetails().getOrderDetail(token, orderId);
      if (orderDetails['success']) {
        return orderDetails; // Return the entire response
      } else {
        if (mounted) {
          _showErrorDialog(orderDetails['error']);
        }
        throw Exception('Failed to fetch order details');
      }
    } catch (error) {
      if (mounted) {
        _showErrorDialog('Error fetching order details: $error');
      }
      throw Exception('Failed to fetch order details');
    }
  }

  void _showErrorDialog(String errorMessage) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: CustomAppBar(
        token: widget.token,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _orderDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator()); // Show a loading indicator
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final orderDetails =
                snapshot.data!['result']; // Access the result map

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "Problem Type: ${orderDetails['ProblemType'] ?? 'Not provided'}"),
                        const SizedBox(height: 20),
                        Text(
                            "Date and Time: ${formatDateTime(orderDetails['orderDate'])}"),
                        const SizedBox(height: 20),
                        Text("Priority: ${orderDetails['priority']}"),
                        const SizedBox(height: 20),
                        const Text("Problem Description"),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              maxLines: null, // Allow multiple lines
                              decoration: InputDecoration(
                                hintText: '${orderDetails['orderDetail']}',
                                border: OutlineInputBorder(
                                  // Add border line
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors
                                        .grey, // You can change the color here
                                    width: 1.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  // Add border when the field is focused
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors
                                        .blue, // Change the color for focused state
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Text(
                                    "Picture: ${orderDetails['orderImage']}")),
                            const Text("View"),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Column(
                          children: [
                            MyButton(
                              text: 'Order Complete',
                              onTap: () {},
                              color: Colors.green,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            MyButton(
                              text: 'Cancel Request',
                              onTap: () {},
                              color: Colors.red,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            MyButton(
                                text: 'Part Request',
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Request(
                                              token: widget.token,
                                              orderId: orderDetails['orderId']
                                                  .toString(),
                                            )),
                                  );
                                }),
                            const SizedBox(
                              height: 20,
                            ),
                            MyButton(
                              text: 'Start Request',
                              onTap: () {},
                              color: AppColors.secondary,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
      bottomNavigationBar: BottomNav(
        onTap: _onTapTapped,
        currentIndex: _currentIndex,
        token: widget.token,
      ),
    );
  }
}
