import 'package:ecommerce_app/core/usecase/usecase.dart';
import 'package:ecommerce_app/features/homepage/domain/entity/product.dart';
import 'package:ecommerce_app/features/homepage/domain/repository/product_repository.dart';

class GetproductbyproductidUsecase extends Usecase<Product, int> {
  final ProductRepository productRepository;
  GetproductbyproductidUsecase(this.productRepository);
  @override
  Future<Product> call(int params) {
    return productRepository.getProductByProductId(params);
  }
}
