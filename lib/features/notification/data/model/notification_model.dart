import 'package:ecommerce_app/features/notification/domain/entity/notification.dart';

class NotificationModel extends Notification {
  NotificationModel({
    required super.id,
    required super.title,
    required super.description,
    required super.userId,
    required super.iconUrl,
    required super.aboutPage,
    required super.receivedAt,
    required super.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      userId: json['userId'] as int,
      iconUrl: json['iconUrl'] as String,
      aboutPage: json['aboutPage'] as String,
      receivedAt: DateTime.parse(json['receivedAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'userId': userId,
      'iconUrl': iconUrl,
      'aboutPage': aboutPage,
      'receivedAt': receivedAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
