import 'package:technician_app/data/models/schedule_model.dart';

abstract class ScheduleRepo {
  Future<List<ScheduleModel>> getSchedule(DateTime data);
  Future<void> addSchedule(ScheduleModel schedule);
  Future<void> deleteSchedule(ScheduleModel schedule);
}
