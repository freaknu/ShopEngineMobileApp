import 'package:ecommerce_app/features/notification/domain/entity/notification.dart';

abstract class NotificationState {}

class NotificationInitialState extends NotificationState {}

class NotificationLoadingState extends NotificationState {}

class NotificationLoadedState extends NotificationState {
  final List<Notification> notifications;

  NotificationLoadedState(this.notifications);
}

class NotificationErrorState extends NotificationState {
  final String message;

  NotificationErrorState(this.message);
}

class NotificationMarkedAsReadState extends NotificationState {
  final String notificationId;

  NotificationMarkedAsReadState(this.notificationId);
}
