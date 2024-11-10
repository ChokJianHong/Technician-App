// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:technician_app/API/cancel.dart';
import 'package:technician_app/API/getOrderDetails.dart';
import 'package:technician_app/Assets/Components/AppBar.dart';
import 'package:technician_app/Pages/Completed_Job_Details.dart';
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
  bool _isRequestStarted = false;

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
      DateTime parsedDate = DateTime.parse(utcDateTime);
      DateTime localDate = parsedDate.toLocal();
      return DateFormat('yyyy-MM-dd').format(localDate);
    } catch (e) {
      print('Error parsing date: $e');
      return 'Invalid date';
    }
  }

  Future<Map<String, dynamic>> _fetchOrderDetails(
      String token, String orderId) async {
    try {
      final orderDetails = await OrderDetails().getOrderDetail(token, orderId);
      if (orderDetails['success']) {
        return orderDetails;
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

  // New method to show cancel confirmation dialog
  void _showCancelDialog() {
    String cancellationReason = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Request'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Please enter the reason for cancellation:'),
              TextField(
                onChanged: (value) {
                  cancellationReason = value; // Update the reason
                },
                decoration: const InputDecoration(
                  hintText: 'Reason for cancellation',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (cancellationReason.isNotEmpty) {
                  _cancelOrder(cancellationReason); // Call the cancel function
                  Navigator.of(context).pop(); // Close the dialog
                } else {
                  // Show an error if the reason is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please provide a reason.')),
                  );
                }
              },
              child: const Text('Confirm'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Function to handle order cancellation
  Future<void> _cancelOrder(String reason) async {
    try {
      final response = await CancelService.declineOrder(
          widget.orderId, reason, widget.token);
      // Handle successful cancellation response
      if (response['status'] == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order cancelled successfully.')),
        );
        // Optionally, navigate back or refresh the page
      }
    } catch (e) {
      // Handle any errors during cancellation
      _showErrorDialog('Failed to cancel order: $e');
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
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final orderDetails = snapshot.data!['result'];

            String brand = 'Unknown brand';
            String warranty = 'Warranty not available';
            if (orderDetails['ProblemType'] == 'autogate') {
              brand =
                  orderDetails['customer']['autogateBrand'] ?? 'Unknown Brand';
              warranty =
                  orderDetails['customer']['autogateWarranty'] ?? 'No warranty';
            } else if (orderDetails['ProblemType'] == 'alarm') {
              brand = orderDetails['customer']['alarmBrand'] ?? 'Unknown Brand';
              warranty =
                  orderDetails['customer']['alarmWarranty'] ?? 'No warranty';
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (orderDetails['orderImage'] != null)
                          Flexible(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  15.0), // Set the border radius
                              child: Image.network(
                                'http://82.112.238.13:5005/${orderDetails['orderImage']}?timestamp=${DateTime.now().millisecondsSinceEpoch}',
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Text("Image not available");
                                },
                              ),
                            ),
                          )
                        else
                          const Text("No Image Available"),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Text(
                        toBeginningOfSentenceCase(
                                orderDetails['ProblemType']) ??
                            'Unknown Problem',
                        style: const TextStyle(
                          color: AppColors.lightgrey,
                          fontWeight: FontWeight.bold,
                          fontSize: 35,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Address',
                          style: TextStyle(
                              color: AppColors.darkGreen,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          orderDetails['locationDetail'] ?? 'Not provided',
                          style: const TextStyle(
                              color: AppColors.lightgrey, fontSize: 15),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Brand',
                              style: TextStyle(
                                  color: AppColors.darkGreen,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              brand,
                              style: const TextStyle(
                                color: AppColors.lightgrey,
                                fontSize: 15,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(width: 100),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Warranty',
                              style: TextStyle(
                                  color: AppColors.darkGreen,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              formatDateTime(warranty),
                              style: TextStyle(color: AppColors.lightgrey),
                            )
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Date',
                              style: TextStyle(
                                  color: AppColors.darkGreen,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              formatDateTime(orderDetails['orderDate']),
                              style: const TextStyle(
                                color: AppColors.lightgrey,
                                fontSize: 15,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(width: 100),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Time',
                              style: TextStyle(
                                  color: AppColors.darkGreen,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              orderDetails['orderTime'],
                              style: TextStyle(color: AppColors.lightgrey),
                            )
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Problem Description",
                      style:
                          TextStyle(fontSize: 20, color: AppColors.darkGreen),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      orderDetails['orderDetail'],
                      style: const TextStyle(
                          color: AppColors.lightgrey, fontSize: 15),
                    ),
                    const SizedBox(height: 40),
                    Column(
                      children: [
                        MyButton(
                          text: _isRequestStarted
                              ? 'Complete Request'
                              : 'Start Request',
                          onTap: () {
                            setState(() {
                              if (_isRequestStarted) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CompletedJobDetails(
                                      token: widget.token,
                                      orderId: widget.orderId,
                                    ),
                                  ),
                                );
                              } else {
                                // Code to handle starting the request (maybe change state or show a message)
                              }
                              _isRequestStarted =
                                  !_isRequestStarted; // Toggle the button state
                            });
                          },
                          color: _isRequestStarted
                              ? Colors.green
                              : AppColors.orange,
                        ),
                        const SizedBox(height: 20),
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
                        const SizedBox(height: 20),
                        MyButton(
                          text: 'Cancel Request',
                          onTap: _showCancelDialog, // Call the dialog method
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ],
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
