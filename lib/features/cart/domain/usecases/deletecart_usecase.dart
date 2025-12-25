import 'package:ecommerce_app/core/usecase/usecase.dart';
import 'package:ecommerce_app/features/cart/domain/repository/cart_repository.dart';

class DeletecartUsecase extends Usecase<bool, int> {
  final CartRepository cartRepository;
  DeletecartUsecase(this.cartRepository);
  @override
  Future<bool> call(int params) {
    return cartRepository.deleteFromCart(params);
  }
}
