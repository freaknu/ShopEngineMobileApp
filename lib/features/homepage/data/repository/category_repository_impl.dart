import 'package:ecommerce_app/features/homepage/data/datasource/remote/category_api_service.dart';
import 'package:ecommerce_app/features/homepage/domain/entity/category.dart';
import 'package:ecommerce_app/features/homepage/domain/repository/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryApiService categoryApiService;
  CategoryRepositoryImpl(this.categoryApiService);
  @override
  Future<List<Category>> getAllCategories() {
    return categoryApiService.getAllCategories();
  }
}
