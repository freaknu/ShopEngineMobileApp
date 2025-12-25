import 'package:ecommerce_app/core/usecase/usecase.dart';
import 'package:ecommerce_app/features/homepage/domain/entity/product.dart';
import 'package:ecommerce_app/features/homepage/domain/repository/product_repository.dart';

class SearchproductUsecase extends Usecase<List<Product>, String> {
  final ProductRepository productRepository;

  SearchproductUsecase(this.productRepository);

  @override
  Future<List<Product>> call(String params) {
    return productRepository.searchProduct(params);
  }
}
