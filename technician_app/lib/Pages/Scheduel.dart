import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:technician_app/Assets/Components/AppBar.dart';
import 'package:technician_app/Assets/Components/BottomNav.dart';
import 'dart:collection';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  int _currentIndex = 1;

  // Add calendar-related states
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  // Store events in a map
  Map<DateTime, List<String>> _events = LinkedHashMap(
    equals: isSameDay,
    hashCode: (DateTime day) => day.day * 1000000 + day.month * 10000 + day.year,
  );

  // Handle bottom navigation bar tap
  void _onTapTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // Get events for the selected day
  List<String> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  // Show dialog to add events
  Future<void> _addEventDialog() async {
    String eventText = '';

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Event'),
        content: TextField(
          onChanged: (value) {
            eventText = value;
          },
          decoration: const InputDecoration(hintText: "Enter event details"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                if (_selectedDay != null && eventText.isNotEmpty) {
                  if (_events[_selectedDay!] == null) {
                    _events[_selectedDay!] = [];
                  }
                  _events[_selectedDay!]!.add(eventText);
                }
              });
              Navigator.of(context).pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF391370),
      appBar: CustomAppBar(),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2024, 1, 1),
            lastDay: DateTime.utc(2024, 12, 30),
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
            // Indicate which days have events
            eventLoader: (day) {
              return _getEventsForDay(day);
            },
            // Customize text style to white and add dots for events
            calendarStyle: CalendarStyle(
              defaultTextStyle: const TextStyle(color: Colors.white),
              weekendTextStyle: const TextStyle(color: Colors.white),
              selectedTextStyle: const TextStyle(color: Colors.white),
              todayTextStyle: const TextStyle(color: Colors.white),
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
          // Display events for the selected day
          Expanded(
            child: ListView(
              children: _getEventsForDay(_selectedDay ?? _focusedDay)
                  .map((event) => ListTile(
                        title: Text(event, style: const TextStyle(color: Colors.white)),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEventDialog,
        child: const Icon(Icons.add),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF391370),
      ),
      bottomNavigationBar: BottomNav(
        onTap: _onTapTapped,
        currentIndex: _currentIndex,
      ),
    );
  }
}
