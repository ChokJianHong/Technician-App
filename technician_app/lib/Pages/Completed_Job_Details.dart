// ignore_for_file: file_names
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:technician_app/API/getOrderDetails.dart';
import 'package:technician_app/Assets/Components/AppBar.dart';
import 'package:technician_app/Pages/payment.dart';
import 'package:technician_app/assets/components/BottomNav.dart';
import 'package:technician_app/assets/components/button.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:technician_app/core/configs/theme/appColors.dart';

class CompletedJobDetails extends StatefulWidget {
  final String token;
  final String orderId;

  const CompletedJobDetails(
      {super.key, required this.token, required this.orderId});

  @override
  State<CompletedJobDetails> createState() => _CompletedJobDetailsState();
}

class _CompletedJobDetailsState extends State<CompletedJobDetails> {
  int _currentIndex = 2;
  late Future<Map<String, dynamic>> _orderDetailFuture;
  final ImagePicker _picker = ImagePicker();
  File? _image;

  void _onTapTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _orderDetailFuture = _fetchOrderDetails(widget.token, widget.orderId);
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

  // Function to capture an image with the camera
  Future<void> _captureImageWithCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String> _getTechnicianIdFromToken(String token) async {
    try {
      final decodedToken = JwtDecoder.decode(token);
      return decodedToken['userId']?.toString() ?? 'default';
    } catch (error) {
      return 'default';
    }
  }

  Future<Map<String, dynamic>> _uploadImage(
      File imageFile, String orderId) async {
    try {
      var request = http.MultipartRequest(
        'PUT', // Change PUT to POST
        Uri.parse(
            'http://82.112.238.13:5005/dashboarddatabase/orders/$orderId/upload-image'), // Confirm this URL
      );

      // Add the authorization header
      request.headers['Authorization'] = widget.token;

      // Add the image file
      request.files.add(
        await http.MultipartFile.fromPath(
          'image', // Confirm the key name with the backend
          imageFile.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );

      // Send the request
      var response = await request.send();

      // Get the response
      var responseBody = await http.Response.fromStream(response);

      if (responseBody.statusCode == 200) {
        return jsonDecode(responseBody.body);
      } else {
        throw Exception(
            'Upload failed with status: ${responseBody.statusCode}');
      }
    } catch (e) {
      throw Exception('Error uploading image: $e');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: CustomAppBar(
        token: widget.token,
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
                  children: [
                    const SizedBox(height: 10),
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
                      height: 20,
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
                    const SizedBox(height: 20),
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
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
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
                            const SizedBox(
                              width: 100,
                            ),
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
                                    color: AppColors.lightgrey,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
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
                                    color: AppColors.lightgrey,
                                    fontSize: 15,
                                  ),
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
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          'Evidence of Completion',
                          style: TextStyle(
                              color: AppColors.darkGreen,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        Column(
                          children: [
                            _image != null
                                ? Image.file(_image!)
                                : const Placeholder(
                                    fallbackHeight: 200.0,
                                    fallbackWidth: double.infinity,
                                  ),
                            ElevatedButton(
                              onPressed: _captureImageWithCamera,
                              child: const Text('Take Picture'),
                            ),
                            const SizedBox(height: 40),
                            MyButton(
                              text: 'Continue',
                              color: AppColors.orange,
                              onTap: () => _pictureTaken(),
                            ),
                          ],
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
      bottomNavigationBar: BottomNav(
        onTap: _onTapTapped,
        currentIndex: _currentIndex,
        token: widget.token,
      ),
    );
  }

  void _pictureTaken() async {
    // Check if an image has been selected
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select or take a picture!')),
      );
      return;
    }

    // Show loading indicator while uploading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      // Send data and image together
      final result = await _uploadImage(_image!, widget.orderId);

      // Dismiss loading indicator
      Navigator.of(context).pop();

      // Handle the server response
      if (result['message'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Form submitted successfully!')),
        );

        // Fetch Technician ID from the token
        String technicianId = await _getTechnicianIdFromToken(widget.token);

        // Navigate to the Payment page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Payment(
              token: widget.token,
              orderId: widget.orderId,
              technicianId: technicianId,
            ),
          ),
        );
      } else {
        // Handle server error response
        String errorMessage = result['message'] ?? 'An error occurred';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $errorMessage')),
        );
      }
    } catch (error) {
      // Dismiss loading indicator on error
      Navigator.of(context).pop();

      // Handle network or other unexpected errors
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Network error: Unable to submit form')),
      );
    }
  }
}
