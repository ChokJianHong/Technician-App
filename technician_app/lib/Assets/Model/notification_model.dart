class NotificationModel {
  final String title;
  final String body;
  final Map<String, dynamic> data;

  NotificationModel({
    required this.title,
    required this.body,
    required this.data,
  });

  // Factory constructor to parse FCM data
  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      title: map['notification']?['title'] ?? 'No Title',
      body: map['notification']?['body'] ?? 'No Body',
      data: map['data'] ?? {},
    );
  }
}
