import 'package:ecommerce_app/features/notification/data/datasource/notification_datasource.dart';
import 'package:ecommerce_app/features/notification/domain/entity/notification.dart';
import 'package:ecommerce_app/features/notification/domain/repository/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationDatasource notificationDatasource;
  
  NotificationRepositoryImpl(this.notificationDatasource);
  
  @override
  Future<List<Notification>> getAllNotifications() async {
    try {
      return await notificationDatasource.getAllNotifications();
    } catch (e) {
      throw Exception('Failed to get notifications: $e');
    }
  }

}
