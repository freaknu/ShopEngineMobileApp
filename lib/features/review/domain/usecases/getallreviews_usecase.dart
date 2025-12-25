import 'package:ecommerce_app/core/usecase/usecase.dart';
import 'package:ecommerce_app/features/review/domain/entity/review.dart';
import 'package:ecommerce_app/features/review/domain/repository/review_repository.dart';

class GetallreviewsUsecase extends Usecase<List<Review>, int> {
  final ReviewRepository repository;
  GetallreviewsUsecase(this.repository);
  @override
  Future<List<Review>> call(int params) {
    return repository.getAllReviews(params);
  }
}
