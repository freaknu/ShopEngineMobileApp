import 'package:ecommerce_app/core/usecase/usecase.dart';
import 'package:ecommerce_app/features/homepage/domain/entity/product.dart';
import 'package:ecommerce_app/features/homepage/domain/repository/product_repository.dart';

class GetallproductsbycategoryidUsecase
    extends Usecase<List<Product>, GetAllProductsByCategoryIdArgs> {
  final ProductRepository productRepository;
  GetallproductsbycategoryidUsecase(this.productRepository);
  @override
  Future<List<Product>> call(GetAllProductsByCategoryIdArgs params) {
    return productRepository.getAllProductsByCategoryId(params);
  }
}

class GetAllProductsByCategoryIdArgs {
  final int categoryId;
  final int page;
  final int pageSize;

  GetAllProductsByCategoryIdArgs(this.categoryId, this.page, this.pageSize);
}
