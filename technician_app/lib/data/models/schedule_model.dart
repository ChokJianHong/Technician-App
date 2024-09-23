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

  // Factory constructor to create a ScheduleModel from a map
  factory ScheduleModel.fromMap(Map<String, dynamic> map) {
    return ScheduleModel(
      id: map['id'] as String,
      startTime: DateTime.parse(
          map['startTime']), // Ensure startTime is parsed to DateTime
      endTime: DateTime.parse(
          map['endTime']), // Ensure endTime is parsed to DateTime
      description: map['description'] as String,
    );
  }

  // Optional: You can also add a toMap method to convert back to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'description': description,
    };
  }
}
