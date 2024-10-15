import 'package:flutter/material.dart';
import 'package:technician_app/API/view_order.dart';
import 'package:technician_app/Assets/Components/newJobCard.dart';
import 'package:technician_app/Assets/Model/order_model.dart';
import 'package:technician_app/Pages/pending.dart';

class NewJobs extends StatefulWidget {
  final String token;

  const NewJobs({super.key, required this.token});

  @override
  State<NewJobs> createState() => _NewJobsState();
}

class _NewJobsState extends State<NewJobs> {
  late Future<List<OrderModel>> _pendingOrdersFuture;

  @override
  void initState() {
    super.initState();
    // Fetch pending orders from the API
    _pendingOrdersFuture = _fetchPendingOrders();
  }

  Future<List<OrderModel>> _fetchPendingOrders() {
    return OrderService().getPendingOrders(widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<OrderModel>>(
      future: _pendingOrdersFuture,
      builder: (context, snapshot) {
        // Check if the request is still in progress
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        // Check if there was an error in the request
        else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error fetching orders: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _pendingOrdersFuture = _fetchPendingOrders(); // Retry fetching orders
                    });
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        // Check if data was received successfully
        else if (snapshot.hasData) {
          final List<OrderModel> pendingOrders = snapshot.data!;

          // If there are no pending orders, show a message
          if (pendingOrders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'No ongoing orders.',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _pendingOrdersFuture = _fetchPendingOrders(); // Reload orders
                      });
                    },
                    child: const Text('Refresh'),
                  ),
                ],
              ),
            );
          }

          // Use a fixed-height container for the ListView
          return SizedBox(
            height: 300, // Set a specific height for the ListView
            child: ListView.builder(
              itemCount: pendingOrders.length,
              itemBuilder: (context, index) {
                final OrderModel order = pendingOrders[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to the Pending page when an order is tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Pending(
                            token: widget.token,
                            orderId: order.orderId.toString(),
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
                  ),
                );
              },
            ),
          );
        }
        return const SizedBox(); // Fallback in case of unexpected state
      },
    );
  }
}
