import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/constants/Api/api_endpoints.dart';
import 'package:ecommerce_app/features/notification/data/model/notification_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationDatasource {
  Dio dio = Dio();
  final String notificationUrl = 'http://34.58.229.119:9000/';
  Future<List<NotificationModel>> getAllNotifications() async {
    try {
      final pref = await SharedPreferences.getInstance();
      int? userId = pref.getInt('user_id');
      final endpoint = ApiEndpoints().getAllNotifications;
      final response = await dio.get('$notificationUrl$endpoint$userId');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data.map((json) => NotificationModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      throw Exception('Error fetching notifications: $e');
    }
  }
}
