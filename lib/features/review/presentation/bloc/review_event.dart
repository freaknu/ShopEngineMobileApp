import 'package:ecommerce_app/features/review/domain/entity/review.dart';

abstract class ReviewEvent {}

class ReviewGetAllEvent extends ReviewEvent {
  final int productId;
  ReviewGetAllEvent(this.productId);
}

class ReviewAddEvent extends ReviewEvent {
  final int  productId;
  final Review reviewCreate;
  ReviewAddEvent(this.productId, this.reviewCreate);
}
