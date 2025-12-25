import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_app/core/usecase/usecase.dart';
import 'package:ecommerce_app/features/homepage/domain/usecases/getallcategories_usecase.dart';
import 'package:ecommerce_app/features/homepage/presentation/bloc/category_bloc/category_event.dart';
import 'package:ecommerce_app/features/homepage/presentation/bloc/category_bloc/category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetallcategoriesUsecase getAllCategories;

  CategoryBloc({required this.getAllCategories})
      : super(CategoryInitial()) {
    on<GetAllCategoriesEvent>(_onGetAllCategories);
  }

  Future<void> _onGetAllCategories(
    GetAllCategoriesEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    try {
      final categories = await getAllCategories(NoArgs());
      emit(CategoryLoaded(categories: categories));
    } catch (e) {
      emit(CategoryFailure(message: e.toString()));
    }
  }
}
