// ignore_for_file: file_names
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:technician_app/API/getOrderDetails.dart';
import 'package:technician_app/Assets/Components/AppBar.dart';
import 'package:technician_app/Pages/home.dart';
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
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(localDate);
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

  Future<Map<String, dynamic>> _uploadImageAndData(
      File imageFile, String orderId) async {
    try {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse(
            'http://10.0.2.2:5005/dashboarddatabase/orders/$orderId/mark-complete'),
      );

      // Add the authorization header
      request.headers['Authorization'] = widget.token;

      // Add the image file
      request.files.add(
        await http.MultipartFile.fromPath(
          'image', // Adjust this key based on your backend expectation
          imageFile.path,
          contentType:
              MediaType('image', 'jpeg'), // Adjust for the correct type
        ),
      );

      // Send the request
      var response = await request.send();

      // Get the response
      var responseBody = await http.Response.fromStream(response);

      print('Response status: ${responseBody.statusCode}');
      print('Response body: ${responseBody.body}');

      if (responseBody.statusCode == 200) {
        return jsonDecode(responseBody.body);
      } else {
        throw Exception(
            'Upload failed with status: ${responseBody.statusCode}');
      }
    } catch (e) {
      print('Error uploading image and data: $e');
      throw Exception('Upload failed');
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

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "Location: ${orderDetails['locationDetail'] ?? 'Not provided'}"),
                        const SizedBox(height: 20),
                        Text(
                            "Date and Time: ${formatDateTime(orderDetails['orderDate'])}"),
                        const SizedBox(height: 20),
                        Text("Priority: ${orderDetails['priority']}"),
                        const SizedBox(height: 20),
                        const Text("Problem Description"),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              maxLines: null,
                              decoration: InputDecoration(
                                hintText: '${orderDetails['orderDetail']}',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                    width: 1.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                    color: Colors.blue,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Text(
                                    "Picture: ${orderDetails['orderImage']}")),
                            const Text("View"),
                          ],
                        ),
                        const SizedBox(height: 20),
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
                              onTap: () => _pictureTaken(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
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
          const SnackBar(content: Text('Please select or take a picture!')));
      return;
    }

    try {
      // Send data and image together
      final result = await _uploadImageAndData(_image!, widget.orderId);
      print(result);
      if (result['message'] == 'success') {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(token: widget.token)),
        ); // Navigate to confirmation page
      } else {
        String errorMessage = result['message'] ?? 'An error occurred';
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $errorMessage')));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Network error: Unable to create order')));
    }
  }
}
