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
  late Future<List<OrderModel>> _pendingOrdersFuture;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _pendingOrdersFuture = _fetchPendingOrders();

    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      setState(() {
        _pendingOrdersFuture = _fetchPendingOrders();
      });
    });
  }

  Future<List<OrderModel>> _fetchPendingOrders() {
    return OrderService().getPendingOrders(widget.token);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<OrderModel>>(
      future: _pendingOrdersFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error fetching orders: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else if (snapshot.hasData) {
          final List<OrderModel> pendingOrders = snapshot.data!;

          if (pendingOrders.isEmpty) {
            return const Center(
              child: Text(
                'No ongoing orders.',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            );
          }

          return SizedBox(
            height: 300,
            child: ListView.builder(
              itemCount: pendingOrders.length,
              itemBuilder: (context, index) {
                final OrderModel order = pendingOrders[index];
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
        return const SizedBox();
      },
    );
  }
}
