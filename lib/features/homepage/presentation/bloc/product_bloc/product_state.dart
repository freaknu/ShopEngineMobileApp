abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {
  final String loadingMessage;
  ProductLoading({required this.loadingMessage});
}

class ProductSearching extends ProductState {
  final String keyword;
  ProductSearching({required this.keyword});
}

class ProductLoaded extends ProductState {
  final dynamic data;
  final String successMessage;

  ProductLoaded({required this.data, required this.successMessage});
}

class ProductFailure extends ProductState {
  final String failureMessage;
  ProductFailure({required this.failureMessage});
}