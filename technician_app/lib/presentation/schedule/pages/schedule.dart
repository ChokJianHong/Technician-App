import 'package:flutter/material.dart';
import 'package:technician_app/common/widgets/appbar/appbar.dart';
import 'package:technician_app/data/models/schedule_model.dart';
import 'package:technician_app/data/repository/schedule_repo.dart';
import 'package:technician_app/data/sources/calender_data_source.dart';
import 'package:technician_app/domain/repositories/schedule_repo_domain.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:math';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<Schedule> {
  final ScheduleRepo _calendarRepository =
      ScheduleRepoImpl(CalendarDataSource());

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now(); // Initialize to today
  List<ScheduleModel> _events = [];

  @override
  void initState() {
    super.initState();
    _loadEvents(); // Load events initially for today
  }

  Future<void> _loadEvents() async {
    if (_selectedDay != null) {
      final events = await _calendarRepository.getSchedule(_selectedDay!);
      setState(() {
        _events = events;
      });
    }
  }

  Future<void> _newEvents() async {
    if (_selectedDay != null) {
      // Create a new ScheduleModel instance with dummy data
      final newEvent = ScheduleModel(
        id: _generateUniqueId(), // Generate a unique ID
        description: 'New Event', // Example description
        startTime: _selectedDay!.add(Duration(hours: 1)), // Example start time
        endTime: _selectedDay!.add(Duration(hours: 2)), // Example end time
      );

      // Add the new event using the repository
      await _calendarRepository.addSchedule(newEvent);

      // Fetch the updated list of events for the selected day
      final events = await _calendarRepository.getSchedule(_selectedDay!);

      // Update the state to reflect the new events
      setState(() {
        _events = events;
      });
    }
  }

  // Generate a unique ID for new events
  String _generateUniqueId() {
    final random = Random();
    return random.nextInt(100000).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavBar(
        showBackButton: true,
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                _loadEvents(); // Load events for the newly selected day
              });
            },
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            calendarFormat: CalendarFormat.month,
            eventLoader: (day) {
              return _events
                  .where((event) =>
                      event.startTime.isSameDay(day) ||
                      event.endTime.isSameDay(day))
                  .toList();
            },
          ),
          Expanded(
            child: ListView(
              children: _events
                  .map((event) => ListTile(
                        title: Text(event.description),
                        subtitle: Text('${event.startTime} - ${event.endTime}'),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _newEvents, // Trigger adding new events
        child: Icon(Icons.add),
      ),
    );
  }
}

extension DateTimeX on DateTime {
  bool isSameDay(DateTime other) {
    return this.year == other.year &&
        this.month == other.month &&
        this.day == other.day;
  }
}
