import 'package:ecommerce_app/core/usecase/usecase.dart';
import 'package:ecommerce_app/features/product/domain/entity/inventory.dart';
import 'package:ecommerce_app/features/product/domain/repository/product_repository.dart';

class GetinventorybyidUsecase extends Usecase<Inventory, int> {
  final ProductRepository _productRepository;
  GetinventorybyidUsecase(this._productRepository);
  @override
  Future<Inventory> call(int params) {
    return _productRepository.getInventoryByProductId(params);
  }
}
