import 'package:ecommerce_app/core/usecase/usecase.dart';
import 'package:ecommerce_app/features/cart/domain/entity/cart.dart';
import 'package:ecommerce_app/features/cart/domain/repository/cart_repository.dart';

class GetallcartsUsecase extends Usecase<Cart, int> {
  final CartRepository cartRepository;
  GetallcartsUsecase(this.cartRepository);
  @override
  Future<Cart> call(int params) {
    return cartRepository.getAllCarts();
  }
}
