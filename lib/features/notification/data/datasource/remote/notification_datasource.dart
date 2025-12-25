import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/constants/Api/api_endpoints.dart';
import 'package:ecommerce_app/features/notification/data/model/notification_model.dart';
import 'package:ecommerce_app/features/notification/domain/entity/notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationDatasource {
  final Dio _dio;
  NotificationDatasource(this._dio);
  final String notificationUrl = 'http://34.58.229.119:9000/';

  Future<List<Notification>> getAllNotifications() async {
    try {
      final pref = await SharedPreferences.getInstance();
      int? userId = pref.getInt('user_id');
      String endpoint = ApiEndpoints().getAllNotifications;
      final res = await _dio.get('$notificationUrl$endpoint$userId');
      if (res.statusCode == 200 || res.statusCode == 201) {
        List json = res.data;
        List<Notification> notifications = json
            .map((n) => NotificationModel.fromJson(n))
            .toList();
        return notifications;
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
