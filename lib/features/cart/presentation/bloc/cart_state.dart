import '../../domain/entity/cart.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final Cart cart;
  CartLoaded(this.cart);
}

class CartFailed extends CartState {
  final String message;
  CartFailed(this.message);
}
