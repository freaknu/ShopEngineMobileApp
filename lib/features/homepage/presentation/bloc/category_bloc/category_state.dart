import 'package:ecommerce_app/features/homepage/domain/entity/category.dart';

abstract class CategoryState {}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<Category> categories;

  CategoryLoaded({required this.categories});
}

class CategoryFailure extends CategoryState {
  final String message;

  CategoryFailure({required this.message});
}
