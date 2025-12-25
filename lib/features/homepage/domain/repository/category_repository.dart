import 'package:ecommerce_app/features/homepage/domain/entity/category.dart';

abstract class CategoryRepository {
  Future<List<Category>> getAllCategories();
}
