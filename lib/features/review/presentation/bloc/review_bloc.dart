import 'package:ecommerce_app/features/review/domain/usecases/createreview_usecase.dart';
import 'package:ecommerce_app/features/review/domain/usecases/getallreviews_usecase.dart';
import 'package:ecommerce_app/features/review/presentation/bloc/review_event.dart';
import 'package:ecommerce_app/features/review/presentation/bloc/review_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final GetallreviewsUsecase getallreviewsUsecase;
  final CreatereviewUsecase createreviewUsecase;
  ReviewBloc({
    required this.getallreviewsUsecase,
    required this.createreviewUsecase,
  }) : super(ReviewInitialState()) {
    on<ReviewGetAllEvent>(_onGetAllReviews);
    on<ReviewAddEvent>(_onReviewCreate);
  }

  Future<void> _onGetAllReviews(
    ReviewGetAllEvent event,
    Emitter<ReviewState> emit,
  ) async {
    emit(ReviewLoadingState());
    try {
      final res = await getallreviewsUsecase(event.productId);
      emit(ReviewSuccessState(res));
    } catch (e) {
      emit(ReviewFailureState());
    }
  }

  Future<void> _onReviewCreate(
    ReviewAddEvent event,
    Emitter<ReviewState> emit,
  ) async {
    emit(ReviewLoadingState());
    try {
      print("under the review bloc");
      final res = await createreviewUsecase(
        CreateReviewArgs(event.reviewCreate, event.productId),
      );

      emit(ReviewCreatedState(res));
    } catch (e) {
      emit(ReviewFailureState());
    }
  }
}
