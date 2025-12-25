import 'package:ecommerce_app/core/usecase/usecase.dart';
import 'package:ecommerce_app/features/homepage/domain/entity/product.dart';
import 'package:ecommerce_app/features/homepage/domain/repository/product_repository.dart';

class GetllproductsUsecase extends Usecase<List<Product>, ProductGetArguments> {
  final ProductRepository productRepository;
  GetllproductsUsecase(this.productRepository);
  @override
  Future<List<Product>> call(ProductGetArguments params) async {
    final res = await productRepository.getAllProducts(params);
    print("the re sshajs $res");
    return productRepository.getAllProducts(params);
  }
}

class ProductGetArguments {
  final int page;
  final int pageSize;
  ProductGetArguments(this.page, this.pageSize);
}
