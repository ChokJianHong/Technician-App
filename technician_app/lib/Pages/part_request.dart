import 'package:flutter/material.dart';
import 'package:technician_app/API/getCust.dart';
import 'package:technician_app/API/getOrderDetails.dart';
import 'package:technician_app/API/req.dart';
import 'package:technician_app/API/getTechnician.dart'; // Import Technician API service
import 'package:technician_app/Assets/Components/detail.dart';
import 'package:technician_app/assets/components/text_box.dart';
import '../assets/components/button.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart'; // Import the jwt_decoder package

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
  final Req _requestApi = Req();
  final TechnicianService _technicianService =
      TechnicianService(); // Add TechnicianService instance
  String technicianName =
      "Loading..."; // Set default loading state for technician name

  @override
  void initState() {
    super.initState();

    // Decode the token to extract the technician ID
    String technicianId;
    try {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(widget.token);
      technicianId = decodedToken['userId'].toString(); // Adjust key as needed
      print('Technician ID: $technicianId');
    } catch (error) {
      print('Error decoding token: $error');
      technicianId = 'default'; // Set a default value if decoding fails
    }

    // Fetch the technician's name using the technician ID
    _fetchTechnicianName(technicianId);
    _combinedDetailsFuture =
        _fetchOrderAndCustomerDetails(widget.token, widget.orderId);
  }

  // Fetch technician details using the technician ID
  void _fetchTechnicianName(String technicianId) async {
    try {
      // Fetch technician details using the ID
      Map<String, dynamic> technicianDetails =
          await TechnicianService.getTechnician(widget.token, technicianId);

      // Access the technician data from the response
      if (technicianDetails['technician'] != null &&
          technicianDetails['technician'].isNotEmpty) {
        // Extract technician details from the first element of the array
        String name = technicianDetails['technician'][0]['name'];

        // Update technician name in the state
        setState(() {
          technicianName = name; // Set technician name from the API response
        });
      } else {
        throw Exception("Technician details are empty or missing.");
      }
    } catch (error) {
      print("Error fetching technician details: $error");
      setState(() {
        technicianName = "Unknown"; // Set a fallback name in case of an error
      });
    }
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

  Future<void> _handleRequestSubmission(
      Map<String, dynamic> customerData, Map<String, dynamic> orderData) async {
    try {
      if (technicianName == "Loading..." || technicianName == "Unknown") {
        _showErrorDialog(
            "Technician's name is not available yet. Please try again.");
        return;
      }

      final String customerId = customerData['customerId'].toString();
      final String customerName = customerData['name'];
      final String equipment = orderData['ProblemType'] ?? '';
      final String brand =
          customerData['autogateBrand'] ?? customerData['alarmBrand'] ?? '';
      final String partsNeeded = _newsearchController.text;

      // Submit the request form with the technician's name and other details
      await _requestApi.createRequestForm(
        technicianName: technicianName, // Use fetched technician name
        customerId: customerId,
        customerName: customerName,
        equipment: equipment,
        brand: brand,
        partsNeeded: partsNeeded,
      );

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
      appBar: AppBar(title: const Text('Request Parts')),
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

            final orderData = snapshot.data!['order'] ?? {};
            final customerData = snapshot.data!['customer'] ?? {};

            // Determine brand and warranty fields based on ProblemType
            String problemType = orderData['ProblemType'] ?? 'Unknown Problem';
            String brand = 'Unknown Brand';
            String warranty = 'No warranty';

            if (problemType == 'autogate') {
              brand = customerData['autogateBrand'] ?? 'Unknown Brand';
              warranty = customerData['autogateWarranty'] ?? 'No warranty';
            } else if (problemType == 'alarm') {
              brand = customerData['alarmBrand'] ?? 'Unknown Brand';
              warranty = customerData['alarmWarranty'] ?? 'No warranty';
            }

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Client Details:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ClientBox(
                    name: customerData['name'] ?? 'Unknown Name',
                    brand: brand,
                    warranty: formatDateTime(warranty),
                    date: formatDateTime(
                        orderData['orderDate'] ?? DateTime.now().toString()),
                    time: orderData['orderTime'] ?? 'No time available',
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Parts Request:',
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
