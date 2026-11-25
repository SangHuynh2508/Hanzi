/// Contract for scheduling local review reminders.
///
/// The platform notification implementation is part of D4.
class NotificationService {
  Future<void> init() async {}

  Future<bool> requestPermission() async => false;

  Future<void> scheduleDailyReminder(int minutesOfDay) async {}

  Future<void> cancelReminder() async {}
}
