import 'package:ecommerce_app/core/usecase/usecase.dart';
import 'package:ecommerce_app/features/order/domain/entity/order_create.dart';
import 'package:ecommerce_app/features/order/domain/repository/order_repository.dart';

class OrderplaceUsecase extends Usecase<bool, OrderCreate>{
  final OrderRepository orderRepository;

  OrderplaceUsecase(this.orderRepository);
  @override
  Future<bool> call(OrderCreate order) {
    print("the adddress id under usecase ${order.addressId}");
    return orderRepository.placeOrder(order);
  }
}