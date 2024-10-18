import 'package:flutter/material.dart';
import 'package:technician_app/API/getCust.dart';
import 'package:technician_app/API/getOrderDetails.dart';
import 'package:technician_app/API/Req.dart'; // Import the request form API
import 'package:technician_app/Assets/Components/detail.dart';
import 'package:technician_app/assets/components/text_box.dart';
import '../assets/components/button.dart';

class Request extends StatefulWidget {
  final String token;
  final String orderId;

  const Request({
    super.key,
    required this.token,
    required this.orderId,
  });

  @override
  State<Request> createState() => _RequestState();
}

final TextEditingController _newsearchController = TextEditingController();

class _RequestState extends State<Request> {
  late Future<Map<String, dynamic>> _combinedDetailsFuture;
  final Req _requestApi = Req(); // Initialize the request API

  @override
  void initState() {
    super.initState();
    _combinedDetailsFuture =
        _fetchOrderAndCustomerDetails(widget.token, widget.orderId);
  }

  // Fetch order details, extract customerId, and then fetch customer details
  Future<Map<String, dynamic>> _fetchOrderAndCustomerDetails(
      String token, String orderId) async {
    try {
      // Fetch the order details
      final orderDetails = await OrderDetails().getOrderDetail(token, orderId);
      if (orderDetails['success']) {
        final String customerId = orderDetails['result']['CustomerID']
            .toString(); // Extract customerId

        // Fetch customer details using the customerId from the order details
        final customerDetails = await getCustomerDetails(customerId);

        // Combine both order and customer details into one map
        return {
          'order': orderDetails['result'],
          'customer': customerDetails,
        };
      } else {
        _showErrorDialog(orderDetails['error']);
        throw Exception('Failed to fetch order details');
      }
    } catch (error) {
      _showErrorDialog('Error fetching order or customer details: $error');
      throw Exception('Failed to fetch order or customer details');
    }
  }

  // Function to handle the request submission
  Future<void> _handleRequestSubmission(
      Map<String, dynamic> customerData, Map<String, dynamic> orderData) async {
    try {
      final String technicianName =
          "Technician Name"; // Replace with actual technician name
      final String customerId = customerData['customerId'].toString();
      final String customerName =
          customerData['name'].toString(); // Ensure this is a string
      final String equipment =
          customerData['alarmBrand'] ?? ''; // Handle null case
      final String brand =
          customerData['autogateBrand'] ?? ''; // Handle null case
      final String partsNeeded = _newsearchController.text;

      await _requestApi.createRequestForm(
        technicianName: technicianName,
        customerId: customerId,
        equipment: equipment,
        brand: brand,
        partsNeeded: partsNeeded,
      );

      // Show success message
      _showSuccessDialog("Request Form submitted successfully!");
    } catch (error) {
      _showErrorDialog('Failed to submit request: $error');
    }
  }

  // Display an error dialog if needed
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

  // Display a success dialog
  void _showSuccessDialog(String message) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: Text(message),
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
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(),
      // Fetch and display both customer and order details
      body: SingleChildScrollView(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _combinedDetailsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No data found.'));
            }

            final orderData = snapshot.data!['order']; // Order details
            final customerData = snapshot.data!['customer']; // Customer details

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Client Details: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ClientBox(
                    name: customerData['name'],
                    brand: customerData['autogateBrand'] ??
                        customerData['alarmBrand'],
                    model: orderData['ProblemType'],
                    date: orderData['orderDate'],
                    time: orderData['orderTime'],
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Parts Request: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  MyTextField(
                    controller: _newsearchController,
                    hintText: 'Parts Needed',
                    obscureText: false,
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 150)),
                  MyButton(
                    text: "Request Parts",
                    onTap: () {
                      // Call the request submission function with data
                      _handleRequestSubmission(customerData, orderData);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
