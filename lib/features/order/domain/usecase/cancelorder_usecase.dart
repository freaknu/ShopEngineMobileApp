import 'package:ecommerce_app/core/usecase/usecase.dart';
import 'package:ecommerce_app/features/order/domain/repository/order_repository.dart';

class CancelorderUsecase extends Usecase<bool, int> {
  final OrderRepository orderRepository;
  CancelorderUsecase(this.orderRepository);
  @override
  Future<bool> call(int params) {
    return orderRepository.cancelOrder(params);
  }
}
