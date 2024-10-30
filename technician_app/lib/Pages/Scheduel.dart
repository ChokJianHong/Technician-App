import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:technician_app/Assets/Components/AppBar.dart';
import 'package:technician_app/Assets/Components/BottomNav.dart';
import 'package:technician_app/API/get_job_order.dart';
import 'package:technician_app/Assets/Model/order_model.dart';
import 'package:technician_app/Assets/Components/NewJobcard.dart'; // import the NewJobcard component
import 'dart:collection';

import 'package:technician_app/Pages/Job_Details.dart';
import 'package:technician_app/core/configs/theme/appColors.dart';

class Schedule extends StatefulWidget {
  final String token;
  const Schedule({super.key, required this.token});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  int _currentIndex = 2;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final Map<DateTime, List<OrderModel>> _events = LinkedHashMap(
    equals: isSameDay,
    hashCode: (DateTime day) =>
        day.day * 1000000 + day.month * 10000 + day.year,
  );

  @override
  void initState() {
    super.initState();
    _fetchOngoingOrders();
  }

  Future<void> _fetchOngoingOrders() async {
    try {
      // Fetch ongoing orders from the API
      final orders = await TechnicianJobOrder()
          .getTechnicianJobs(widget.token, 'technicianId');

      // Filter and organize only ongoing orders by their date
      final ongoingOrders =
          orders.where((order) => order.orderStatus == 'ongoing').toList();
      final ordersByDate = groupBy(ongoingOrders, (OrderModel order) {
        final orderDate = DateTime.parse(order.orderDate).toLocal();
        return DateTime(orderDate.year, orderDate.month, orderDate.day);
      });

      // Update _events map to store events for each date
      setState(() {
        _events.clear();
        ordersByDate.forEach((date, ordersList) {
          _events[date] = ordersList;
        });
      });
    } catch (e) {
      print('Error fetching ongoing orders: $e');
    }
  }

  List<OrderModel> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: CustomAppBar(token: widget.token),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2024, 12, 31),
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            eventLoader: _getEventsForDay,
            calendarStyle: const CalendarStyle(
              defaultTextStyle: TextStyle(color: Colors.white),
              weekendTextStyle: TextStyle(color: Colors.white),
              selectedTextStyle: TextStyle(color: Colors.white),
              todayTextStyle: TextStyle(color: Colors.white),
              markerDecoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: Colors.white),
              weekendStyle: TextStyle(color: Colors.white),
            ),
            headerStyle: const HeaderStyle(
              titleTextStyle: TextStyle(color: Colors.white),
              formatButtonTextStyle: TextStyle(color: Colors.white),
              leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
              rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              children: _getEventsForDay(_selectedDay ?? _focusedDay)
                  .map((order) => GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RequestDetails(
                                token: widget.token,
                                orderId: order.orderId.toString(),
                              ),
                            ),
                          );
                        },
                        child: NewJobcard(
                          name: order.problemType,
                          location: order.locationDetails,
                          jobType: order.urgencyLevel,
                          status: order.orderStatus,
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNav(
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        currentIndex: _currentIndex,
        token: widget.token,
      ),
    );
  }
}
