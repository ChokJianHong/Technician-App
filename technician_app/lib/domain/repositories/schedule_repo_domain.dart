import 'package:technician_app/data/models/schedule_model.dart';
import 'package:technician_app/data/repository/schedule_repo.dart';
import 'package:technician_app/data/sources/calender_data_source.dart';

class ScheduleRepoImpl implements ScheduleRepo {
  final CalendarDataSource remoteDataSource;

  ScheduleRepoImpl(this.remoteDataSource);

  @override
  Future<void> addSchedule(ScheduleModel event) async {
    await remoteDataSource.createEvent({
      'id': event.id,
      'description': event.description,
      'start': {
        'dateTime': event.startTime.toIso8601String(),
      },
      'end': {
        'dateTime': event.endTime.toIso8601String(),
      },
    });
  }

  @override
  Future<void> deleteSchedule(ScheduleModel event) async {
    await remoteDataSource.deleteEvent(event.id);
  }

  @override
  Future<List<ScheduleModel>> fetchTechnicianEvents(
      DateTime day, String technicianId) async {
    try {
      final events = await remoteDataSource.getEventsForDay(
          day, technicianId); // Ensure this returns a valid list
      return events.map((event) => ScheduleModel.fromMap(event)).toList();
    } catch (e) {
      print('Error fetching events for technician: $e');
      return []; // Return an empty list on error or if no events are found
    }
  }
}
