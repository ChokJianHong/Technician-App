// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:technician_app/API/cancel.dart';
import 'package:technician_app/API/getOrderDetails.dart';
import 'package:technician_app/API/sendTechLocation.dart';

import 'package:technician_app/Pages/Completed_Job_Details.dart';
import 'package:technician_app/Pages/home.dart';
import 'package:technician_app/Pages/messages.dart';
import 'package:technician_app/Pages/part_request.dart';

import 'package:technician_app/assets/components/button.dart';
import 'package:technician_app/core/configs/theme/appColors.dart';

class RequestDetails extends StatefulWidget {
  final String token;
  final String orderId;

  const RequestDetails({super.key, required this.token, required this.orderId});

  @override
  State<RequestDetails> createState() => _RequestDetailsState();
}

class _RequestDetailsState extends State<RequestDetails> {
  late Future<Map<String, dynamic>> _orderDetailFuture;
  bool _isRequestStarted = false;

  @override
  void initState() {
    super.initState();
    _orderDetailFuture = _fetchOrderDetails(widget.token, widget.orderId);
    _loadRequestState();
  }

  Future<void> _loadRequestState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isRequestStarted = prefs.getBool('isRequestStarted') ?? false;
    });
  }

  Future<void> _saveRequestState(bool state) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isRequestStarted', state);
  }

  // Function to get current location
  Future<Position> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        throw Exception("Location permissions are denied");
      }
    }
    return await Geolocator.getCurrentPosition();
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

  // Function to get technician ID from token
  Future<String> getTechnicianIdFromToken(String token) async {
    String technicianId = '';

    try {
      // Decode the token to extract the technician ID
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      technicianId = decodedToken['userId']
          .toString(); // Adjust the key based on your token structure
      print('Technician ID: $technicianId');
    } catch (error) {
      print('Error decoding token: $error');
      technicianId = 'default'; // Set a default value if decoding fails
    }

    return technicianId; // Return the technician ID
  }

  Future<void> _changeStatus() async {
    // Get technician ID from token
    String technicianId = await getTechnicianIdFromToken(widget.token);

    final sendTechLocation = Sendtechlocation();

    if (technicianId != 'default') {
      // Change the status to 'working'
      await sendTechLocation.changeStatus(
          widget.token, technicianId, 'working');

      // Optionally, update the UI to reflect the status change
      setState(() {
        _isRequestStarted = true;
      });

      // Optionally, save the request state to SharedPreferences
      await _saveRequestState(true);
    } else {
      // Handle the case when the technician ID is invalid
      print("Invalid technician ID. Cannot start the request.");
    }
  }

  // Function to send location data
  Future<void> sendLocationData(
      double longitude, double latitude, String token) async {
    final sendTechLocation = Sendtechlocation();

    // Get technician ID from the token
    String technicianId = await getTechnicianIdFromToken(token);

    // Ensure technicianId is valid before sending location data
    if (technicianId != 'default' && technicianId.isNotEmpty) {
      try {
        await sendTechLocation.sendLocation(
            technicianId, latitude, longitude, token);
        print("Location sent successfully!");
      } catch (e) {
        print("Error sending location: $e");
      }
    } else {
      print("Invalid technician ID. Cannot send location.");
    }
  }

  Future<void> sendCurrentTime(
      String orderid, String token, String currentTime) async {
    final sendtechlocation = Sendtechlocation();

    try {
      await sendtechlocation.sendTime(orderid, token, currentTime);
      print("Time Sent Successfully");
    } catch (err) {
      print("Error sending location: $err");
    }
  }

  Future<Map<String, dynamic>> _fetchOrderDetails(
      String token, String orderId) async {
    try {
      final orderDetails = await OrderDetails().getOrderDetail(token, orderId);
      if (orderDetails['success']) {
        return orderDetails;
      } else {
        if (mounted) {
          _showErrorDialog(orderDetails['error']);
        }
        throw Exception('Failed to fetch order details');
      }
    } catch (error) {
      if (mounted) {
        _showErrorDialog('Error fetching order details: $error');
      }
      throw Exception('Failed to fetch order details');
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

  // New method to show cancel confirmation dialog
  void _showCancelDialog() {
    String cancellationReason = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Request'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Please enter the reason for cancellation:'),
              TextField(
                onChanged: (value) {
                  cancellationReason = value; // Update the reason
                },
                decoration: const InputDecoration(
                  hintText: 'Reason for cancellation',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (cancellationReason.isNotEmpty) {
                  Navigator.of(context).pop(); // Close the dialog
                  await _cancelOrder(
                      cancellationReason); // Call the cancel function outside of setState
                } else {
                  // Show an error if the reason is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please provide a reason.')),
                  );
                }
              },
              child: const Text('Confirm'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Function to handle order cancellation
  Future<void> _cancelOrder(String reason) async {
    try {
      final response = await CancelService.declineOrder(
          widget.orderId, reason, widget.token);
      // Handle successful cancellation response
      if (response['status'] == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order cancelled successfully.')),
        );
        // Optionally, navigate back or refresh the page
      }
    } catch (e) {
      // Handle any errors during cancellation
      _showErrorDialog('Failed to cancel order: $e');
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
      body: FutureBuilder<Map<String, dynamic>>(
        future: _orderDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final orderDetails = snapshot.data!['result'];

            String brand = 'Unknown brand';
            String warranty = 'Warranty not available';
            if (orderDetails['ProblemType'] == 'autogate') {
              brand =
                  orderDetails['customer']['autogateBrand'] ?? 'Unknown Brand';
              warranty =
                  orderDetails['customer']['autogateWarranty'] ?? 'No warranty';
            } else if (orderDetails['ProblemType'] == 'alarm') {
              brand = orderDetails['customer']['alarmBrand'] ?? 'Unknown Brand';
              warranty =
                  orderDetails['customer']['alarmWarranty'] ?? 'No warranty';
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (orderDetails['orderImage'] != null)
                          Flexible(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  15.0), // Set the border radius
                              child: Image.network(
                                'http://82.112.238.13:5005/${orderDetails['orderImage']}?timestamp=${DateTime.now().millisecondsSinceEpoch}',
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
                        toBeginningOfSentenceCase(
                                orderDetails['ProblemType']) ??
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Address',
                          style: TextStyle(
                              color: AppColors.darkGreen,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          orderDetails['locationDetail'] ?? 'Not provided',
                          style: const TextStyle(
                              color: AppColors.lightgrey, fontSize: 15),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Brand',
                                  style: TextStyle(
                                      color: AppColors.darkGreen,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  brand,
                                  style: const TextStyle(
                                    color: AppColors.lightgrey,
                                    fontSize: 15,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(width: 100),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Warranty',
                                  style: TextStyle(
                                      color: AppColors.darkGreen,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  formatDateTime(warranty),
                                  style: const TextStyle(
                                      color: AppColors.lightgrey),
                                )
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Date',
                                  style: TextStyle(
                                      color: AppColors.darkGreen,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  formatDateTime(orderDetails['orderDate']),
                                  style: const TextStyle(
                                    color: AppColors.lightgrey,
                                    fontSize: 15,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(width: 100),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Time',
                                  style: TextStyle(
                                      color: AppColors.darkGreen,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  orderDetails['orderTime'],
                                  style: const TextStyle(
                                      color: AppColors.lightgrey),
                                )
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Problem Description",
                          style: TextStyle(
                              fontSize: 20, color: AppColors.darkGreen),
                        ),
                        Text(
                          orderDetails['orderDetail'],
                          style: const TextStyle(
                              color: AppColors.lightgrey, fontSize: 15),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Column(
                      children: [
                        MyButton(
                          text: _isRequestStarted
                              ? 'Complete Request'
                              : 'Start Request',
                          onTap: () async {
                            if (_isRequestStarted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CompletedJobDetails(
                                    token: widget.token,
                                    orderId: widget.orderId,
                                  ),
                                ),
                              );
                            } else {
                              try {
                                // Get the current location asynchronously
                                Position position = await _getCurrentLocation();
                                double longitude = position.longitude;
                                double latitude = position.latitude;

                                // Send location data with technicianId
                                sendLocationData(
                                    longitude, latitude, widget.token);

                                DateTime currentTime = DateTime.now();

                                sendCurrentTime(widget.orderId, widget.token,
                                    currentTime.toIso8601String());

                                // Make Technician Free
                                _changeStatus();

                                // Update the state synchronously
                                setState(() {
                                  _isRequestStarted = true;
                                });

                                await _saveRequestState(true);
                              } catch (e) {
                                print("Error getting location: $e");
                              }
                            }
                          },
                          color: _isRequestStarted
                              ? Colors.green
                              : AppColors.orange,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.blue, // Set button color if needed
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                          ),
                          onPressed: () {
                            // Replace these with actual values
                            String currentUserId = widget
                                .token; // Or retrieve it from the order or user context
                            String chatPartnerId = widget
                                .orderId; // Or the technician's ID or another identifier
                            String token = widget.token;

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                  currentUserId: currentUserId,
                                  chatPartnerId: chatPartnerId,
                                  token: token,
                                ),
                              ),
                            );
                          },
                          child: const Text('Go to Messages'),
                        ),
                        const SizedBox(height: 10),
                        MyButton(
                            text: 'Part Request',
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Request(
                                          token: widget.token,
                                          orderId: orderDetails['orderId']
                                              .toString(),
                                        )),
                              );
                            }),
                        const SizedBox(height: 20),
                        MyButton(
                          text: 'Cancel Request',
                          onTap: _showCancelDialog, // Call the dialog method
                          color: Colors.red,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
