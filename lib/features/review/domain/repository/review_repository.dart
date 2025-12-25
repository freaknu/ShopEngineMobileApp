import 'package:ecommerce_app/features/review/domain/entity/review.dart';

abstract class ReviewRepository {
  Future<bool> createReview(Review createReview, int productId);
  Future<List<Review>> getAllReviews(int productId);
}
