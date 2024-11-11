// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:technician_app/API/get_job_order.dart';
import 'package:technician_app/Assets/Components/currentJobCard.dart';
import 'package:technician_app/Assets/Model/order_model.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:technician_app/Pages/Job_Details.dart';

class CurrentJobs extends StatefulWidget {
  final String token;
  const CurrentJobs({super.key, required this.token});

  @override
  _CurrentJobsState createState() => _CurrentJobsState();
}

class _CurrentJobsState extends State<CurrentJobs> {
  late Future<List<OrderModel>> _latestOrderFuture;
  late String technicianId;
  final TechnicianJobOrder technicianJobOrder =
      TechnicianJobOrder();

  @override
  void initState() {
    super.initState();
    try {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(widget.token);
      technicianId = decodedToken['userId'].toString(); // Adjust key as needed
      print('Technician ID: $technicianId');
    } catch (error) {
      print('Error decoding token: $error');
      technicianId = 'default'; // Set a default value if decoding fails
    }

    // Fetch orders using the technician ID
    _latestOrderFuture = technicianId.isNotEmpty
        ? technicianJobOrder.getTechnicianJobs(
            widget.token, technicianId) // Correct method call
        : Future.value([]); // Initialize with an empty list if no technician ID
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<OrderModel>>(
      future: _latestOrderFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          final List<OrderModel> latestOrders = snapshot.data!;
          final ongoingOrders = latestOrders
              .where((order) => order.orderStatus == 'ongoing')
              .toList();

          if (ongoingOrders.isEmpty) {
            return const Text(
              'No ongoing orders.',
              style: TextStyle(color: Colors.white),
            );
          }

          return SizedBox(
            height: 150, 
            child: PageView.builder(
              scrollDirection: Axis.horizontal, 
              controller: PageController(viewportFraction: 0.8),
              itemCount: ongoingOrders.length,
              itemBuilder: (context, index) {
                final OrderModel order = ongoingOrders[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RequestDetails(
                          token: widget.token, orderId: order.orderId.toString(),
                        ),
                      ),
                    );
                    },
                    child: Transform.scale(
                      scale:
                          0.9, // Slight scale effect to create card-like appearance
                      child: JobCard(
                        name: order.problemType,
                        description: order.orderDetail,
                        status: order.orderStatus,
                      ),
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
