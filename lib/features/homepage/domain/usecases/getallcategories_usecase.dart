import 'package:ecommerce_app/core/usecase/usecase.dart';
import 'package:ecommerce_app/features/homepage/domain/entity/category.dart';
import 'package:ecommerce_app/features/homepage/domain/repository/category_repository.dart';

class GetallcategoriesUsecase extends Usecase<List<Category>, NoArgs> {
  final CategoryRepository categoryRepository;
  GetallcategoriesUsecase(this.categoryRepository);
  @override
  Future<List<Category>> call(NoArgs params) {
    return categoryRepository.getAllCategories();
  }
}
