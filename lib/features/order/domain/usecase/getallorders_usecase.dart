import 'package:ecommerce_app/core/usecase/usecase.dart';
import 'package:ecommerce_app/features/order/domain/entity/order_response.dart';
import 'package:ecommerce_app/features/order/domain/repository/order_repository.dart';

class GetallordersUsecase extends Usecase<List<OrderResponse>, NoArgs> {
  final OrderRepository orderRepository;
  GetallordersUsecase(this.orderRepository);
  @override
  Future<List<OrderResponse>> call(NoArgs params) {
    return orderRepository.getAllOrders();
  }
}
