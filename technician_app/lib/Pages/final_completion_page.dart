import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:technician_app/API/getOrderDetails.dart';
import 'package:technician_app/API/request_form_by_id.dart';
import 'package:technician_app/Assets/Components/divider.dart';
import 'package:technician_app/core/configs/theme/appColors.dart';

class FinalCompletionPage extends StatefulWidget {
  final String token;
  final String orderId;
  const FinalCompletionPage(
      {super.key, required this.token, required this.orderId});

  @override
  State<FinalCompletionPage> createState() => _FinalCompletionPageState();
}

class _FinalCompletionPageState extends State<FinalCompletionPage> {
  late Future<Map<String, dynamic>> _orderDetailFuture;
  late Future<List<Map<String, dynamic>>> _partRequestsFuture;

  @override
  void initState() {
    super.initState();
    _partRequestsFuture = _fetchPartRequests();
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

  Future<List<Map<String, dynamic>>> _fetchPartRequests() async {
    try {
      // Use the provided API to fetch part requests by order ID
      final List<Map<String, dynamic>> partRequests =
          await RequestPartService.getRequestFormsByOrderId(
        widget.orderId,
        widget.token,
      );

      // Log the fetched parts for debugging
      print('Fetched part requests: $partRequests');

      return partRequests.isNotEmpty ? partRequests : [];
    } catch (error) {
      print("Error fetching part requests: $error");
      return []; // Return an empty list in case of error
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: AppColors.darkTeal,
      ),
      backgroundColor: AppColors.primary,
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
                        const ADivider(),
                        const Text(
                          'Evidence of Completion',
                          style: TextStyle(
                              color: AppColors.darkGreen,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (orderDetails['orderDoneImage'] != null)
                              Flexible(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      15.0), // Set the border radius
                                  child: Image.network(
                                    'http://82.112.238.13:5005/${orderDetails['orderDoneImage']}?timestamp=${DateTime.now().millisecondsSinceEpoch}',
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
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Date Started',
                                  style: TextStyle(
                                      color: AppColors.darkGreen,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  formatDateTime(orderDetails['orderDate']),
                                  style: const TextStyle(
                                      color: AppColors.lightgrey, fontSize: 15),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 90,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Date Completed',
                                  style: TextStyle(
                                      color: AppColors.darkGreen,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  formatDateTime(orderDetails['orderDoneDate']),
                                  style: const TextStyle(
                                      color: AppColors.lightgrey, fontSize: 15),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        FutureBuilder<List<Map<String, dynamic>>>(
                          future: _partRequestsFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text(
                                    'Error fetching parts: ${snapshot.error}'),
                              );
                            } else if (snapshot.hasData &&
                                snapshot.data!.isNotEmpty) {
                              // Combine all 'parts_needed' fields into a single string
                              final partsList = snapshot.data!
                                  .map((partRequest) =>
                                      partRequest['parts_needed'] ?? '')
                                  .where((part) => part.isNotEmpty)
                                  .toList();

                              final partsNeededText = partsList.isNotEmpty
                                  ? partsList.join(
                                      ', ') // Combine parts into a comma-separated string
                                  : 'No parts needed';

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Parts Needed',
                                    style: TextStyle(
                                      color: AppColors.darkGreen,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    partsNeededText,
                                    style: const TextStyle(
                                      color: AppColors.lightgrey,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              );
                            } else {
                              return const Center(
                                child: Text('No parts available'),
                              );
                            }
                          },
                        )
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
