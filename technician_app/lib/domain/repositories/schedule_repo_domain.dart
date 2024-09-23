import 'package:technician_app/data/models/schedule_model.dart';
import 'package:technician_app/data/repository/schedule_repo.dart';
import 'package:technician_app/data/sources/calender_data_source.dart';

class ScheduleRepoImpl implements ScheduleRepo {
  final CalendarDataSource remoteDataSource;

  ScheduleRepoImpl(this.remoteDataSource);

  @override
  Future<List<ScheduleModel>> getSchedule(DateTime day) async {
    final eventsMap = await remoteDataSource.getEventsForDay(day);
    return eventsMap.map((event) {
      return ScheduleModel(
        id: event['id'],
        description: event['description'],
        startTime: DateTime.parse(event['start']['dateTime']),
        endTime: DateTime.parse(event['end']['dateTime']),
      );
    }).toList();
  }

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
}
