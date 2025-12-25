import 'package:ecommerce_app/features/homepage/domain/entity/product.dart';
import 'package:ecommerce_app/features/homepage/domain/usecases/getallproductsbycategoryid_usecase.dart';
import 'package:ecommerce_app/features/homepage/domain/usecases/getllproducts_usecase.dart';

abstract class ProductRepository {
  Future<List<Product>> getAllProducts(ProductGetArguments args);
  Future<List<Product>> getAllProductsByCategoryId(GetAllProductsByCategoryIdArgs args);
  Future<Product> getProductByProductId(int id);
  Future<List<Product>> searchProduct(String keyword);
}
