import 'package:ecommerce_app/features/review/domain/entity/review.dart';

abstract class ReviewState {}

class ReviewInitialState extends ReviewState {}

class ReviewLoadingState extends ReviewState {}

class ReviewSuccessState extends ReviewState {
  final List<Review> allReviews;
  ReviewSuccessState(this.allReviews);
}

class ReviewFailureState extends ReviewState {}

class ReviewCreatedState extends ReviewState {
  final bool isCreated;
  ReviewCreatedState(this.isCreated);
}
