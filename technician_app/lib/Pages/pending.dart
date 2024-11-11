import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:technician_app/API/accept_job.dart';
import 'package:technician_app/API/getOrderDetails.dart';
import 'package:technician_app/Assets/Components/AppBar.dart';
import 'package:technician_app/Assets/Components/BottomNav.dart';
import 'package:technician_app/Assets/Components/button.dart';
import 'package:technician_app/Pages/home.dart';
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

  Future<void> _acceptOrder() async {
    try {
      String eta =
          DateTime.now().toIso8601String(); // Modify this to get the actual ETA
      double totalAmount = 100.0; // Modify this to get the actual total amount

      await AcceptJob().acceptOrder(
        widget.token,
        int.parse(widget.orderId),
        eta,
        totalAmount,
      );

      // Display a success message or navigate to another page
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text('Order accepted successfully!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomePage(
                                token: widget.token,
                              )),
                    );
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      if (mounted) {
        _showErrorDialog('Failed to accept order: $error');
      }
    }
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

            final orderDetails = snapshot.data!['result'];
            print(orderDetails);

            String locationDetail = orderDetails['locationDetail'] ??
                'Location details not available';
            String orderDate =
                orderDetails['orderDate'] ?? 'Date not available';
            String orderDetail =
                orderDetails['orderDetail'] ?? 'No description available';
            String orderTime = orderDetails['orderTime'] ?? 'Not available';
            String problemType = orderDetails['ProblemType'] ?? 'unknown';

            String brand;
            if (problemType == 'autogate') {
              brand = orderDetails['customer']['autogateBrand'] ??
                  'Brand not available';
            } else if (problemType == 'alarm') {
              brand = orderDetails['customer']['alarmBrand'] ??
                  'Brand not available';
            } else {
              brand = 'Unknown brand';
            }

            String warranty;
            if (problemType == 'autogate') {
              warranty = orderDetails['customer']['autogateWarranty'] ??
                  'Brand not available';
            } else if (problemType == 'alarm') {
              warranty = orderDetails['customer']['alarmWarranty'] ??
                  'Brand not available';
            } else {
              warranty = 'Unknown brand';
            }

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
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
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      toBeginningOfSentenceCase(orderDetails['ProblemType']) ??
                          'Unknown Problem',
                      style: const TextStyle(
                        color: AppColors.lightgrey,
                        fontWeight: FontWeight.bold,
                        fontSize: 35,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Address',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: AppColors.darkGreen),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(locationDetail,
                      style: const TextStyle(
                          fontSize: 15, color: AppColors.lightgrey)),
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
                                  color: AppColors.darkGreen),
                            ),
                            Text(brand,
                                style: const TextStyle(
                                    fontSize: 15, color: AppColors.lightgrey)),
                          ],
                        ),
                        const SizedBox(width: 125),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Warranty',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkGreen),
                            ),
                            Text(
                              formatDateTime(warranty),
                              style: const TextStyle(
                                  fontSize: 15, color: AppColors.lightgrey),
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
                                  color: AppColors.darkGreen),
                            ),
                            Text(formatDateTime(orderDate),
                                style: const TextStyle(
                                    fontSize: 15, color: AppColors.lightgrey)),
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
                                  color: AppColors.darkGreen),
                            ),
                            Text(orderTime,
                                style: const TextStyle(
                                    fontSize: 15, color: AppColors.lightgrey)),
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
                        color: AppColors.darkGreen),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    height: 100,
                    padding:
                        const EdgeInsets.all(10), // Adjust padding as needed
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      orderDetail,
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                      overflow: TextOverflow
                          .ellipsis, // Adds ellipsis if the text overflows
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      MyButton(
                        text: 'Decline',
                        onTap: () {
                          // Implement decline functionality if needed
                        },
                        color: AppColors.orange,
                      ),
                      MyButton(
                        text: 'Accept',
                        onTap: _acceptOrder,
                        color: AppColors.darkGreen,
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
