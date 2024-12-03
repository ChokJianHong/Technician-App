import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:technician_app/API/getTechnician.dart';
import 'package:technician_app/Pages/home.dart';
import 'package:technician_app/core/configs/theme/appColors.dart'; // For formatting timestamps

class ChatScreen extends StatefulWidget {
  final String currentUserId;
  final String chatPartnerId; // orderId
  final String token;

  const ChatScreen({
    super.key,
    required this.currentUserId,
    required this.chatPartnerId,
    required this.token,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late TextEditingController _messageController;
  late Future<Map<String, dynamic>> _orderDetailsFuture;
  late Future<Map<String, dynamic>> _technicianDetailsFuture;
  final ScrollController _scrollController = ScrollController();
  bool _isSending = false; // Track sending state

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _orderDetailsFuture = _fetchOrderDetails(widget.chatPartnerId);
  }

  Future<Map<String, dynamic>> _fetchOrderDetails(String orderId) async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://82.112.238.13:5005/dashboarddatabase/orders/details/$orderId'),
        headers: {'Authorization': widget.token},
      );

      if (response.statusCode == 200) {
        final orderDetails = json.decode(response.body);
        if (orderDetails['result'] != null &&
            orderDetails['result']['orderStatus'] == 'ongoing') {
          final technicianId =
              orderDetails['result']['TechnicianID'].toString();
          _technicianDetailsFuture =
              TechnicianService.getTechnician(widget.token, technicianId);
          return orderDetails;
        } else {
          throw Exception('Order is not ongoing');
        }
      } else {
        throw Exception('Failed to fetch order details');
      }
    } catch (error) {
      throw Exception('Error fetching order details: $error');
    }
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Message cannot be empty')),
      );
      return;
    }

    setState(() {
      _isSending = true; // Set sending state to true
    });

    try {
      final technicianId = await _fetchTechnicianId();
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatPartnerId)
          .collection('messages')
          .add({
        'senderId': widget.currentUserId,
        'receiverId': technicianId,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _messageController.clear();
      _scrollToBottom();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending message: $error')));
    } finally {
      setState(() {
        _isSending = false; // Reset sending state in finally block
      });
    }
  }

  Future<String> _fetchTechnicianId() async {
    final orderDetails = await _orderDetailsFuture;
    return orderDetails['result']['TechnicianID'].toString();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Contact with Technician',
          style: TextStyle(color: AppColors.lightgrey),
        ),
        backgroundColor: AppColors.darkTeal,
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
        future: _orderDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final orderDetails = snapshot.data!;
            return FutureBuilder<Map<String, dynamic>>(
              future: _technicianDetailsFuture,
              builder: (context, technicianSnapshot) {
                if (technicianSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (technicianSnapshot.hasError) {
                  return Center(
                      child: Text('Error: ${technicianSnapshot.error}'));
                } else if (technicianSnapshot.hasData) {
                  final technicianDetails =
                      technicianSnapshot.data!['technician'][0];
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Technician: ${technicianDetails['name']}',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                            'Phone Number: ${technicianDetails['phone_number']}',
                            style: const TextStyle(fontSize: 16)),
                      ),
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('chats')
                              .doc(widget.chatPartnerId)
                              .collection('messages')
                              .orderBy('timestamp')
                              .snapshots(),
                          builder: (context, chatSnapshot) {
                            if (chatSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (chatSnapshot.hasData &&
                                chatSnapshot.data!.docs.isNotEmpty) {
                              final messages = chatSnapshot.data!.docs;
                              return ListView.builder(
                                controller: _scrollController,
                                itemCount: messages.length,
                                itemBuilder: (context, index) {
                                  final message = messages[index]['message'];
                                  final senderId = messages[index]['senderId'];
                                  // Safely handle the timestamp
                                  final timestampData =
                                      messages[index]['timestamp'];
                                  DateTime timestamp;
                                  if (timestampData is Timestamp) {
                                    timestamp = timestampData.toDate();
                                  } else {
                                    // Handle null or unexpected types
                                    timestamp = DateTime
                                        .now(); // Default to current time or handle as needed
                                  }

                                  return Align(
                                    alignment: senderId == widget.currentUserId
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            senderId == widget.currentUserId
                                                ? CrossAxisAlignment.end
                                                : CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(12.0),
                                            decoration: BoxDecoration(
                                              color: senderId ==
                                                      widget.currentUserId
                                                  ? Colors.blue[100]
                                                  : Colors.grey[300],
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                            ),
                                            child: Text(message,
                                                style: const TextStyle(
                                                    fontSize: 16)),
                                          ),
                                          Text(
                                            DateFormat('hh:mm a').format(
                                                timestamp), // Format timestamp
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.black54),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else {
                              return const Center(
                                  child: Text('No messages yet.'));
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _messageController,
                                decoration: const InputDecoration(
                                    labelText: 'Type your message...',
                                    border: OutlineInputBorder()),
                                onSubmitted: (text) => _sendMessage(text),
                              ),
                            ),
                            IconButton(
                              icon: _isSending
                                  ? const CircularProgressIndicator()
                                  : const Icon(Icons.send),
                              onPressed: _isSending
                                  ? null
                                  : () => _sendMessage(_messageController.text),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Center(
                      child: Text('No technician details available'));
                }
              },
            );
          } else {
            return const Center(child: Text('Order not found or not ongoing'));
          }
        },
      ),
    );
  }
}
