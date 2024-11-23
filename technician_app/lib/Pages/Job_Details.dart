import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
  DateTime? technicianStartTime;

  @override
  void initState() {
    super.initState();
    _orderDetailFuture = _fetchOrderDetails(widget.token, widget.orderId);
    _loadRequestState();
  }

  Future<void> _loadRequestState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Load the state specific to the current job (orderId)
      final isStarted =
          prefs.getBool('isRequestStarted_${widget.orderId}') ?? false;
      debugPrint(
          "Loaded isRequestStarted for Job ${widget.orderId}: $isStarted");
      setState(() {
        _isRequestStarted = isStarted;
      });
    } catch (e) {
      debugPrint("Error loading request state: $e");
    }
  }

  Future<void> _saveRequestState(bool state) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Save the state specific to the current job (orderId)
      await prefs.setBool('isRequestStarted_${widget.orderId}', state);
      debugPrint("Saved isRequestStarted for Job ${widget.orderId}: $state");
    } catch (e) {
      debugPrint("Error saving request state: $e");
    }
  }

  Future<Map<String, dynamic>> _fetchOrderDetails(
      String token, String orderId) async {
    try {
      final orderDetails = await OrderDetails().getOrderDetail(token, orderId);
      if (orderDetails['success']) {
        return orderDetails['result'];
      } else {
        _showErrorDialog(orderDetails['error']);
        throw Exception('Failed to fetch order details.');
      }
    } catch (error) {
      _showErrorDialog('Error fetching order details: $error');
      throw Exception('Failed to fetch order details.');
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

  Future<void> _sendLocationData(Position position) async {
    try {
      final technicianId = await _getTechnicianIdFromToken(widget.token);
      if (technicianId != 'default') {
        // Corrected the parameter order: longitude first, latitude second
        await Sendtechlocation().sendLocation(
          technicianId,
          position.longitude, // Longitude comes first
          position.latitude, // Latitude comes second
          widget.token,
        );
      }
    } catch (e) {
      _showErrorDialog("Error sending location: $e");
    }
  }

  Future<Position> _getCurrentLocation() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      final newPermission = await Geolocator.requestPermission();
      if (newPermission == LocationPermission.denied ||
          newPermission == LocationPermission.deniedForever) {
        throw Exception("Location permissions are denied.");
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog() {
    String reason = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Request'),
        content: TextField(
          onChanged: (value) => reason = value,
          decoration: const InputDecoration(
            hintText: 'Reason for cancellation',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              if (reason.isNotEmpty) {
                Navigator.of(context).pop();
                await _cancelOrder(reason);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please provide a reason.')),
                );
              }
            },
            child: const Text('Confirm'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  

  Future<void> _cancelOrder(String reason) async {
    try {
      final response = await CancelService.declineOrder(
          widget.orderId, reason, widget.token);
      if (response['status'] == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order cancelled successfully.')),
        );
      }
    } catch (e) {
      _showErrorDialog("Error cancelling order: $e");
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
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(token: widget.token),
              ),
            );
          },
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
            final orderDetails = snapshot.data!;
            final brand =
                orderDetails['customer']['autogateBrand'] ?? 'Unknown Brand';
            final warranty =
                orderDetails['customer']['autogateWarranty'] ?? 'No warranty';

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (orderDetails['orderImage'] != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        'http://82.112.238.13:5005/${orderDetails['orderImage']}',
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                  else
                    const Text("No Image Available"),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      orderDetails['ProblemType'] ?? 'Unknown Problem',
                      style: const TextStyle(
                        color: AppColors.lightgrey,
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildDetailsSection(
                      'Address', orderDetails['locationDetail']),
                  _buildDetailsSection('Brand', brand),
                  _buildDetailsSection('Warranty', warranty),
                  const SizedBox(height: 20),
                  MyButton(
                    text: _isRequestStarted
                        ? 'Complete Request'
                        : 'Start Request',
                    color: _isRequestStarted ? Colors.green : AppColors.orange,
                    onTap: () async {
                      if (!_isRequestStarted) {
                        // Start Request logic
                        try {
                          final position = await _getCurrentLocation();
                          await _sendLocationData(position);

                          final startTime = DateTime.now();

                          // Update status and start time
                          await Sendtechlocation().changeStatus(
                            technicianId:
                                await _getTechnicianIdFromToken(widget.token),
                            orderId: widget.orderId,
                            token: widget.token,
                            status: 'working',
                          );

                          // Update local state
                          setState(() {
                            _isRequestStarted = true;
                          });

                          // Save the state to SharedPreferences
                          await _saveRequestState(true);

                          debugPrint(
                              "Technician start time set: ${startTime.toIso8601String()}");
                        } catch (e) {
                          _showErrorDialog("Error starting request: $e");
                        }
                      } else {
                        // Complete Request logic
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CompletedJobDetails(
                              token: widget.token,
                              orderId: widget.orderId,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  MyButton(
                    text: 'Cancel Request',
                    onTap: _showCancelDialog,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 20),
                  MyButton(
                      text: 'View Messages',
                      color: Colors.blue,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                    currentUserId: widget.token,
                                    chatPartnerId: widget.orderId,
                                    token: widget.token)));
                      }),
                  const SizedBox(height: 20),
                  MyButton(
                      text: 'Spare Part Request',
                      color: Colors.brown,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Request(
                              token: widget.token,
                              orderId: widget.orderId,
                            ),
                          ),
                        );
                      })
                ],
              ),
            );
          } else {
            return const Center(child: Text('No data available.'));
          }
        },
      ),
    );
  }

  Widget _buildDetailsSection(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.darkGreen,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.lightgrey,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
