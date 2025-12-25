import 'package:ecommerce_app/core/usecase/usecase.dart';
import 'package:ecommerce_app/features/review/domain/entity/review.dart';
import 'package:ecommerce_app/features/review/domain/repository/review_repository.dart';

class CreatereviewUsecase extends Usecase<bool, CreateReviewArgs> {
  final ReviewRepository repository;
  CreatereviewUsecase(this.repository);
  @override
  Future<bool> call(CreateReviewArgs params) {
    print("under call");
    return repository.createReview(params.reviewCreate, params.productId);
  }
}

class CreateReviewArgs {
  final Review reviewCreate;
  final int productId;
  CreateReviewArgs(this.reviewCreate, this.productId);
}
