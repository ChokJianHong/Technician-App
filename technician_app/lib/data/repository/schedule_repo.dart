import 'package:technician_app/data/models/schedule_model.dart';

abstract class ScheduleRepo {
  Future<void> addSchedule(ScheduleModel schedule);
  Future<void> deleteSchedule(ScheduleModel schedule);
  fetchTechnicianEvents(DateTime day, String technicianId);
}
