import 'package:flutter/material.dart';
import 'package:technician_app/API/view_order.dart';
import 'package:technician_app/Assets/Components/newJobCard.dart';
import 'package:technician_app/Assets/Model/order_model.dart';
import 'package:technician_app/Pages/pending.dart';
import 'dart:async';

class NewJobs extends StatefulWidget {
  final String token;

  const NewJobs({super.key, required this.token});

  @override
  State<NewJobs> createState() => _NewJobsState();
}

class _NewJobsState extends State<NewJobs> {
  late List<OrderModel> _pendingOrders; // Maintain the current list of orders
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _pendingOrders = []; 
    _fetchAndUpdatePendingOrders();

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _fetchAndUpdatePendingOrders(); // Fetch new orders every 5 seconds
    });
  }

  // Fetch orders and update the state
  Future<void> _fetchAndUpdatePendingOrders() async {
    List<OrderModel> newOrders =
        await OrderService().getPendingOrders(widget.token);

    // Sort orders by createAt in descending order (newest first)
    newOrders.sort((a, b) => b.createAt.compareTo(a.createAt));

    setState(() {
      // Insert new orders at the top if they are not already in the list
      for (var order in newOrders) {
        if (!_pendingOrders
            .any((existingOrder) => existingOrder.orderId == order.orderId)) {
          _pendingOrders.insert(
              0, order); // Insert new orders at the top (index 0)
        }
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _pendingOrders.isEmpty
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : SizedBox(
            height: 300,
            child: ListView.builder(
              itemCount: _pendingOrders.length,
              itemBuilder: (context, index) {
                final OrderModel order = _pendingOrders[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: GestureDetector(
                    onTap: () {
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
}
