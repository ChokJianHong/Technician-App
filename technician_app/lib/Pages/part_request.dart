import 'package:flutter/material.dart';
import 'package:technician_app/API/getCust.dart';
import 'package:technician_app/API/getOrderDetails.dart';
import 'package:technician_app/API/req.dart';
import 'package:technician_app/API/getTechnician.dart'; // Import Technician API service
import 'package:technician_app/Assets/Components/autocomplete.dart';
import 'package:technician_app/Assets/Components/detail.dart';
import 'package:technician_app/Pages/home.dart';
import 'package:technician_app/core/configs/theme/appColors.dart';
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
  String technicianName =
      "Loading..."; // Default loading state for technician name

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
      technicianId = 'default'; // Default value if decoding fails
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

      if (technicianDetails['technician'] != null &&
          technicianDetails['technician'].isNotEmpty) {
        String name = technicianDetails['technician'][0]['name'];
        setState(() {
          technicianName = name;
        });
      } else {
        throw Exception("Technician details are empty or missing.");
      }
    } catch (error) {
      print("Error fetching technician details: $error");
      setState(() {
        technicianName = "Unknown";
      });
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

  // Fetch order details, extract customerId, and then fetch customer details
  Future<Map<String, dynamic>> _fetchOrderAndCustomerDetails(
      String token, String orderId) async {
    try {
      final orderDetails = await OrderDetails().getOrderDetail(token, orderId);
      if (orderDetails['success']) {
        final String customerId =
            orderDetails['result']['CustomerID'].toString();
        final customerDetails = await getCustomerDetails(customerId);

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
      // Ensure technician name is available
      if (technicianName == "Loading..." || technicianName == "Unknown") {
        _showErrorDialog(
            "Technician's name is not available yet. Please try again.");
        return;
      }

      // Capture the selected spare part from the autocomplete widget
      final String sparePart = _newsearchController.text;

      // Ensure that spare part is selected
      if (sparePart.isEmpty) {
        _showErrorDialog("Please select or enter a spare part.");
        return;
      }

      final String customerId = customerData['customerId'].toString();
      final String customerName = customerData['name'];
      final String equipment = orderData['ProblemType'] ?? '';
      final String brand =
          customerData['autogateBrand'] ?? customerData['alarmBrand'] ?? '';

      // Make the API call to submit the request
      await _requestApi.createRequestForm(
        technicianName: technicianName,
        customerId: customerId,
        customerName: customerName,
        equipment: equipment,
        brand: brand,
        partsNeeded: sparePart, // Pass the spare part to the API
      );

      _showSuccessDialog("Request Form submitted successfully!");
    } catch (error) {
      _showErrorDialog('Failed to submit request: $error');
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
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(token: widget.token)),
          ),
        ),
      ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (orderData['orderImage'] != null)
                        Flexible(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                15.0), // Set the border radius
                            child: Image.network(
                              'http://82.112.238.13:5005/${orderData['orderImage']}?timestamp=${DateTime.now().millisecondsSinceEpoch}',
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
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      toBeginningOfSentenceCase(orderData['ProblemType']) ??
                          'Unknown Problem',
                      style: const TextStyle(
                        color: AppColors.lightgrey,
                        fontWeight: FontWeight.bold,
                        fontSize: 35,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Client Details:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: AppColors.lightgrey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  DefaultTextStyle(
                    style: const TextStyle(color: Colors.white),
                    child: ClientBox(
                      name: customerData['name'] ?? 'Unknown Name',
                      brand: brand,
                      warranty: formatDateTime(warranty),
                      date: formatDateTime(
                          orderData['orderDate'] ?? DateTime.now().toString()),
                      time: orderData['orderTime'] ?? 'No time available',
                    ),
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
                  MyAutocomplete(
                    controller: _newsearchController,
                    hintText: 'Parts Needed',
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 70)),
                  MyButton(
                    text: "Request Parts",
                    color: AppColors.orange,
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
