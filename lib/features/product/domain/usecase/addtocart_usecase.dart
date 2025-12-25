import 'package:ecommerce_app/core/usecase/usecase.dart';
import 'package:ecommerce_app/features/product/domain/entity/cart_product.dart';
import 'package:ecommerce_app/features/product/domain/repository/product_repository.dart';

class AddtocartUsecase extends Usecase<CartProduct, CartProduct> {
  final ProductRepository productRepository;

  AddtocartUsecase(this.productRepository);
  @override
  Future<CartProduct> call(CartProduct params) {
    return productRepository.addToCart(params);
  }
}
