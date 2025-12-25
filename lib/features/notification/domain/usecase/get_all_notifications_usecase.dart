import 'package:ecommerce_app/features/notification/domain/entity/notification.dart';
import 'package:ecommerce_app/features/notification/domain/repository/notification_repository.dart';

class GetAllNotificationsUsecase {
  final NotificationRepository repository;

  GetAllNotificationsUsecase(this.repository);

  Future<List<Notification>> call() async {
    return await repository.getAllNotifications();
  }
}
