class ScheduleModel {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final String description;

  ScheduleModel({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.description,
  });
}
