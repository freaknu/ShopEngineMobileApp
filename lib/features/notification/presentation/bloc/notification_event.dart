abstract class NotificationEvent {}

class GetAllNotificationsEvent extends NotificationEvent {}

class MarkNotificationAsReadEvent extends NotificationEvent {
  final String notificationId;

  MarkNotificationAsReadEvent(this.notificationId);
}
