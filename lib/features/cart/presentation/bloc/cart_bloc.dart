import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/deletecart_usecase.dart';
import '../../domain/usecases/getallcarts_usecase.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetallcartsUsecase getallcartsUsecase;
  final DeletecartUsecase deletecartUsecase;

  CartBloc({
    required this.getallcartsUsecase,
    required this.deletecartUsecase,
  }) : super(CartInitial()) {
    on<CartDataGet>(_onGetCart);
    on<CartDataDelete>(_onDeleteFromCart);
    on<CartDataClear>(_onClearCart);
  }

  /// ---------------- GET ALL CARTS ----------------
  Future<void> _onGetCart(
    CartDataGet event,
    Emitter<CartState> emit,
  ) async {
    print("under the get all carts bloc");
    emit(CartLoading());
    try {
      final cart = await getallcartsUsecase(0);
      emit(CartLoaded(cart));
    } catch (e) {
      emit(CartFailed(e.toString()));
    }
  }

  /// ---------------- DELETE FROM CART ----------------
  Future<void> _onDeleteFromCart(
    CartDataDelete event,
    Emitter<CartState> emit,
  ) async {
    emit(CartLoading());
    try {
      await deletecartUsecase(event.productId);

      // Refresh cart after delete
      final cart = await getallcartsUsecase(0);
      emit(CartLoaded(cart));
    } catch (e) {
      emit(CartFailed(e.toString()));
    }
  }

  /// ---------------- CLEAR ALL CARTS ----------------
  Future<void> _onClearCart(
    CartDataClear event,
    Emitter<CartState> emit,
  ) async {
    emit(CartLoading());
    try {
      for(int i = 0; i < event.allProducts.length; i++) {
      await deletecartUsecase(event.allProducts[i].id); // -1 or a special value to clear all, adjust as per your usecase
      }
      final cart = await getallcartsUsecase(0);
      emit(CartLoaded(cart));
    } catch (e) {
      emit(CartFailed(e.toString()));
    }
  }
}
