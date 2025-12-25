import 'package:ecommerce_app/features/homepage/domain/entity/category.dart';

class CategoryModel extends Category {
  CategoryModel(super.id, super.name, super.description, super.imageUrl);
  factory CategoryModel.fromJson(Map<String, dynamic> data) {
    return CategoryModel(
      data['categoryId'],
      data['categoryName'],
      data['categoryDescription'],
      data['categoryImage'],
    );
  }
}
