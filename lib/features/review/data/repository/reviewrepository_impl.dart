import 'package:ecommerce_app/features/review/data/datasource/remote/review_datasource.dart';
import 'package:ecommerce_app/features/review/data/model/review_model.dart';
import 'package:ecommerce_app/features/review/domain/entity/review.dart';

import 'package:ecommerce_app/features/review/domain/repository/review_repository.dart';

class ReviewrepositoryImpl implements ReviewRepository {
  final ReviewDatasource reviewDatasource;
  ReviewrepositoryImpl(this.reviewDatasource);
  @override
  Future<bool> createReview(Review createReview, int productId) {
    return reviewDatasource.addReview(
      productId,
      ReviewModel(
        id: createReview.id,
        userName: createReview.userName,
        description: createReview.description,
        rating: createReview.rating,
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<List<Review>> getAllReviews(int productId) {
    return reviewDatasource.getAllReviews(productId);
  }
}
