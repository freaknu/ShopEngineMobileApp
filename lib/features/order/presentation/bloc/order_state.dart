import 'package:ecommerce_app/features/order/domain/entity/order_response.dart';

abstract class OrderState {}

class OrderIntialState extends OrderState {}

class OrderLoadingState extends OrderState {}

class AllOrderLoadedState extends OrderState {
  final List<OrderResponse> allOrders;
  AllOrderLoadedState(this.allOrders);
}

class OrderPlacedState extends OrderState {
  final bool isSuccess;
  OrderPlacedState(this.isSuccess);
}

class OrderFailedState extends OrderState {}
