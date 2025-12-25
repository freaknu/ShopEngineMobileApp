import 'package:ecommerce_app/core/usecase/usecase.dart';
import 'package:ecommerce_app/features/product/domain/entity/product.dart';
import 'package:ecommerce_app/features/product/domain/repository/product_repository.dart';

class GetproductbyidUsecase extends Usecase<Product, int> {
  final ProductRepository productRepository;
  GetproductbyidUsecase(this.productRepository);
  @override
  Future<Product> call(int params) {
    return productRepository.getProductById(params);
  }
}
