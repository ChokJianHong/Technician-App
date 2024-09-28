import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:technician_app/API/get_job_order.dart';
import 'package:technician_app/Assets/Components/currentJobCard.dart';
import 'package:technician_app/Assets/Model/order_model.dart';

class NewJobs extends StatefulWidget {
  final String token;
  const NewJobs({super.key, required this.token});

  @override
  State<NewJobs> createState() => _NewJobsState();
}

class _NewJobsState extends State<NewJobs> {
  late Future<List<OrderModel>> _latestOrderFuture;
  late String technicianId;
  final TechnicianJobOrder technicianJobOrder = TechnicianJobOrder(); // Create an instance of TechnicianJobOrder

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
        ? technicianJobOrder.getTechnicianJobs(widget.token, technicianId)
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
              .where((order) => order.orderStatus == 'pending')
              .toList();

          if (ongoingOrders.isEmpty) {
            return const Text(
              'No ongoing orders.',
              style: TextStyle(color: Colors.white),
            );
          }

          // Use ListView.builder for vertical scroll
          return ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(), // Prevent unbounded height issues
            itemCount: ongoingOrders.length,
            itemBuilder: (context, index) {
              final OrderModel order = ongoingOrders[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: GestureDetector(
                  onTap: () {
                    // Add your onTap functionality here
                  },
                  child: JobCard(
                    name: order.problemType,
                    description: order.locationDetails,
                    status: order.orderStatus,
                  ),
                ),
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}
