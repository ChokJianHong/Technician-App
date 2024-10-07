import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:technician_app/API/getOrderDetails.dart';
import 'package:technician_app/Assets/Components/AppBar.dart';
import 'package:technician_app/Assets/Components/BottomNav.dart';
import 'package:technician_app/Assets/Components/button.dart';
import 'package:technician_app/core/configs/theme/appColors.dart';

class Pending extends StatefulWidget {
  final String token;
  final String orderId;

  const Pending({super.key, required this.token, required this.orderId});

  @override
  State<Pending> createState() => _PendingState();
}

class _PendingState extends State<Pending> {
  int _currentIndex = 1;
  late Future<Map<String, dynamic>> _orderDetailFuture;

  @override
  void initState() {
    super.initState();
    _orderDetailFuture = _fetchOrderDetails(widget.token, widget.orderId);
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
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
      appBar: CustomAppBar(token: widget.token),
      body: SingleChildScrollView(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _orderDetailFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || !snapshot.data!['success']) {
              return const Center(child: Text('No jobs found.'));
            }

            // Extract order details
            final orderDetails = snapshot.data!['result'];

            // Debugging: Print the entire orderDetails map
            print(
                orderDetails); // This line helps to check the structure of the response

            // Safely extract data using null checks
            String locationDetail = orderDetails['locationDetail'] ??
                'Location details not available';
            String orderDate =
                orderDetails['orderDate'] ?? 'Date not available';
            String orderDetail =
                orderDetails['orderDetail'] ?? 'No description available';
            String orderTime = orderDetails['orderTime'] ??
                'Not available'; // Placeholder for order time
            String problemType =
                orderDetails['ProblemType'] ?? 'unknown'; // Added default value

            // Set the brand based on problem type
            String brand;
            if (problemType == 'autogate') {
              brand = orderDetails['customer']['autogateBrand'] ??
                  'Brand not available';
            } else if (problemType == 'alarm') {
              brand = orderDetails['customer']['alarmBrand'] ??
                  'Brand not available'; // Assuming this field exists
            } else {
              brand = 'Unknown brand';
            }

            String formatDateTime(String utcDateTime) {
              try {
                // Parse the UTC date string into a DateTime object
                DateTime parsedDate = DateTime.parse(utcDateTime);

                // Convert the UTC date to local time
                DateTime localDate = parsedDate.toLocal();

                // Format the local date into a desired string format
                return DateFormat('yyyy-MM-dd')
                    .format(localDate); // Adjust format as needed
              } catch (e) {
                // Handle potential parsing errors
                print('Error parsing date: $e');
                return 'Invalid date'; // Return a default value or error message
              }
            }

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Auto Gate',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Image.asset('lib/Assets/Images/problem.png'),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Address',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.white),
                  ),
                  Text(
                    locationDetail,
                    style: const TextStyle(fontSize: 15, color: Colors.white),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Brand',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              brand,
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(width: 115),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Model',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              'eGate X1 Mini', // Update if your API provides this
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Date',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              formatDateTime(orderDate),
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(width: 90),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Time',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              orderTime,
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Description of the Problem',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    maxLines: 3,
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      hintText: orderDetail,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      MyButton(
                        text: 'Decline',
                        onTap: () {},
                        color: Color(0xFF554E6B),
                      ),
                      MyButton(
                        text: 'Accept',
                        onTap: () {},
                        color: Color(0xFF8FA78C),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNav(
        onTap: _onTap,
        currentIndex: _currentIndex,
        token: widget.token,
      ),
    );
  }
}
