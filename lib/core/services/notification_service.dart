/// Notification service abstraction.
/// Wire flutter_local_notifications here when ready.
class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  Future<void> initialize() async {
    // TODO: Initialize flutter_local_notifications
    // final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    // ...
  }

  Future<void> scheduleEmissionReminders(DateTime dueDate) async {
    // Schedule 30d, 7d, 1d before dueDate
    // TODO: implement with flutter_local_notifications
  }

  Future<void> cancelAllReminders() async {
    // TODO: implement with flutter_local_notifications
  }
}
