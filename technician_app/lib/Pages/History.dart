// ignore_for_file: file_names

import 'package:flutter/material.dart';
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

  String? _selectedStatus;
  final List<String> _statusOptions = [
    'All',
    'Pending',
    'OnGoing',
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
    _ordersFuture = _fetchOrders();
  }

  Future<Map<String, List<OrderModel>>> _fetchOrders() async {
    final orders = await TechnicianJobOrder()
        .getTechnicianJobs(widget.token, customerId, status: _selectedStatus);
    final groupedOrders = groupBy(orders, (OrderModel order) => order.orderDate);
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
            DropdownButton<String>(
              hint: const Text(
                'Select Order Status',
                style: TextStyle(color: Colors.white),
              ),
              value: _selectedStatus,
              items: _statusOptions.map((String status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(
                    status,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedStatus = newValue;
                  _ordersFuture = _fetchOrders();
                });
              },
              dropdownColor: AppColors.secondary,
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
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
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
