import 'package:ecommerce_app/features/homepage/data/datasource/remote/product_api_service.dart';
import 'package:ecommerce_app/features/homepage/domain/entity/product.dart';
import 'package:ecommerce_app/features/homepage/domain/repository/product_repository.dart';
import 'package:ecommerce_app/features/homepage/domain/usecases/getallproductsbycategoryid_usecase.dart';
import 'package:ecommerce_app/features/homepage/domain/usecases/getllproducts_usecase.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductApiService apiService;
  ProductRepositoryImpl(this.apiService);
  @override
  Future<List<Product>> getAllProducts(ProductGetArguments args) async{
    final res = await apiService.getAllProducts(args);
    print("the product at product repo impl $res");
    return apiService.getAllProducts(args);
  }

  @override
  Future<List<Product>> getAllProductsByCategoryId(
    GetAllProductsByCategoryIdArgs args,
  ) {
    return apiService.getAllProductsByCategoryId(args);
  }

  @override
  Future<Product> getProductByProductId(int id) {
    return apiService.getByProductId(id);
  }

  @override
  Future<List<Product>> searchProduct(String keyword) {
    return apiService.searchProducts(keyword);
  }
}
