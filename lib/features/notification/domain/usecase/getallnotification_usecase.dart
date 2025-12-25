import 'package:ecommerce_app/core/usecase/usecase.dart';
import 'package:ecommerce_app/features/notification/domain/entity/notification.dart';
import 'package:ecommerce_app/features/notification/domain/repository/notification_repository.dart';

class GetallnotificationUsecase extends Usecase<List<Notification>, NoArgs> {
  final NotificationRepository notificationRepository;
  GetallnotificationUsecase(this.notificationRepository);
  @override
  Future<List<Notification>> call(NoArgs params) {
    return notificationRepository.getAllNotifications();
  }
}
