import 'package:ecommerce_app/core/usecase/usecase.dart';
import 'package:ecommerce_app/features/product/domain/entity/discount.dart';
import 'package:ecommerce_app/features/product/domain/repository/product_repository.dart';

class GetallcouponsbyproductidUsecase extends Usecase<List<Discount>, int> {
  final ProductRepository productRepository;
  GetallcouponsbyproductidUsecase(this.productRepository);
  @override
  Future<List<Discount>> call(int params) {
    return productRepository.getAllDiscounts(params);
  }
}
