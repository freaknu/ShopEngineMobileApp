import 'package:ecommerce_app/features/order/domain/entity/order_create.dart';
import 'package:ecommerce_app/features/order/domain/entity/order_response.dart';

abstract class OrderRepository {
  Future<List<OrderResponse>> getAllOrders();
  Future<bool> placeOrder(OrderCreate data);
  Future<bool> cancelOrder(int orderId);
}
