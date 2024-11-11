// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:technician_app/API/get_job_order.dart';
import 'package:technician_app/Assets/Components/AppBar.dart';
import 'package:technician_app/Assets/Components/BottomNav.dart';
import 'package:technician_app/Assets/Components/newJobCard.dart';
import 'package:technician_app/Assets/Model/order_model.dart';
import 'package:technician_app/Pages/Job_Details.dart';
import 'package:technician_app/core/configs/theme/appColors.dart';
import 'package:collection/collection.dart';

class History extends StatefulWidget {
  final String token;

  const History({super.key, required this.token});

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  late Future<Map<String, List<OrderModel>>> _ordersFuture;
  late String customerId;
  int _currentIndex = 0;

  // Update status options to include only Completed and Cancelled
  String? _selectedStatus;
  final List<String> _statusOptions = [
    'Completed',
    'Cancelled'
  ];

  void _onTapTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    try {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(widget.token);
      customerId = decodedToken['technician_id'];
    } catch (error) {
      print('Error decoding token: $error');
      customerId = 'default';
    }
    // Set the default selected status
    _selectedStatus = _statusOptions.first;
    _ordersFuture = _fetchOrders();
  }

  String formatDateTime(String utcDateTime) {
    try {
      DateTime parsedDate = DateTime.parse(utcDateTime);
      DateTime localDate = parsedDate.toLocal();
      DateTime now = DateTime.now();

      // Calculate the difference in days between the current date and the local date
      int differenceInDays = now.difference(localDate).inDays;

      if (differenceInDays == 0) {
        return 'Today';
      } else if (differenceInDays == 1) {
        return 'Yesterday';
      } else if (differenceInDays <= 7) {
        return 'Last Week';
      } else {
        return DateFormat('yyyy-MM-dd').format(localDate); // Format date for older entries
      }
    } catch (e) {
      print('Error parsing date: $e');
      return 'Invalid date';
    }
  }

  Future<Map<String, List<OrderModel>>> _fetchOrders() async {
    final orders = await TechnicianJobOrder()
        .getTechnicianJobs(widget.token, customerId, status: _selectedStatus);

    // Group orders by formatted date
    final groupedOrders =
        groupBy(orders, (OrderModel order) => formatDateTime(order.orderDate));
    return groupedOrders;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(token: widget.token),
      backgroundColor: AppColors.primary,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            
            const Text(
              'History',
              style: TextStyle(color: Colors.white, fontSize: 16),

            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<Map<String, List<OrderModel>>>(
                future: _ordersFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (snapshot.hasData) {
                    final groupedOrders = snapshot.data!;
                    return ListView.builder(
                      itemCount: groupedOrders.keys.length,
                      itemBuilder: (context, index) {
                        final date = groupedOrders.keys.elementAt(index);
                        final orders = groupedOrders[date]!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                date,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            ...orders.map((order) => GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => RequestDetails(
                                          orderId: order.orderId.toString(),
                                          token: widget.token,
                                        ),
                                      ),
                                    );
                                  },
                                  child: NewJobcard(
                                    name: order.problemType,
                                    location: order.locationDetails,
                                    jobType: order.urgencyLevel,
                                    status: order.orderStatus,
                                  ),
                                )),
                          ],
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text('No orders available'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(
        onTap: _onTapTapped,
        currentIndex: _currentIndex,
        token: widget.token,
      ),
    );
  }
}
