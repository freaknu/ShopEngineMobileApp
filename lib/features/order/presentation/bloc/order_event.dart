import 'package:ecommerce_app/features/order/domain/entity/order_create.dart';

abstract class OrderEvent {}

class OrderPlaceEvent extends OrderEvent {
  final OrderCreate data;
  OrderPlaceEvent(this.data);
}

class OrderCancelEvent extends OrderEvent {
  final int orderId;
  OrderCancelEvent(this.orderId);
}

class OrderGetAllEvent extends OrderEvent {}
