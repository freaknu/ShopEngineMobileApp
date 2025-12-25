import 'package:ecommerce_app/features/notification/domain/entity/notification.dart';

abstract class NotificationRepository {
  Future<List<Notification>> getAllNotifications();
}
