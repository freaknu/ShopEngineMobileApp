import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecase/getproductbyid_usecase.dart';
import '../../domain/usecase/getinventorybyid_usecase.dart';
import '../../domain/usecase/addtocart_usecase.dart';
import '../../domain/usecase/placeproductorder_usecase.dart';
import '../../domain/usecase/getallcouponsbyproductid_usecase.dart';

import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetproductbyidUsecase getProductByIdUsecase;
  final GetinventorybyidUsecase getInventoryByIdUsecase;
  final AddtocartUsecase addtocartUsecase;
  final PlaceproductorderUsecase placeproductorderUsecase;
  final GetallcouponsbyproductidUsecase getAllCouponsByProductIdUsecase;
  ProductBloc({
    required this.getProductByIdUsecase,
    required this.getInventoryByIdUsecase,
    required this.addtocartUsecase,
    required this.placeproductorderUsecase,
    required this.getAllCouponsByProductIdUsecase,
  }) : super(ProductInitialState()) {
    on<GetProductByIdEvent>(_onGetProduct);
    on<ProductAddToCartEvent>(_onAddToCart);
    on<ProductOrderPlaceEvent>(_onPlaceOrder);
    on<ProductAllByProductIdsEvent>(_onGetProductsByIds);
    on<ProductCouponGetEvent>(_onGetAllCoupons);
  }

  /// ---------------- GET PRODUCT + INVENTORY ----------------
  Future<void> _onGetProduct(
    GetProductByIdEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoadingState());
    try {
      final product = await getProductByIdUsecase(event.id);
      final inventory = await getInventoryByIdUsecase(event.id);

      // Emit product first
      emit(ProductLoadedState(product: product, inventory: inventory));

      // 🔥 NOW fetch coupons (state is ProductLoadedState)
      add(ProductCouponGetEvent(event.id));
    } catch (e) {
      emit(ProductLoadingFailedState(e.toString()));
    }
  }

  /// ---------------- ADD TO CART ----------------
  Future<void> _onAddToCart(
    ProductAddToCartEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoadingState());
    try {
      await addtocartUsecase(event.cartProduct);
      emit(ProductAddToCartState("Added to cart successfully!"));
    } catch (e) {
      emit(ProductLoadingFailedState(e.toString()));
    }
  }

  /// ---------------- PLACE ORDER ----------------
  Future<void> _onPlaceOrder(
    ProductOrderPlaceEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoadingState());
    try {
      await placeproductorderUsecase(
        PlaceOrderData(event.orderProduct),
      );

      emit(ProductPlacedOrder("Order placed successfully!"));
    } catch (e) {
      emit(ProductLoadingFailedState(e.toString()));
    }
  }

  /// ---------------- GET PRODUCTS BY IDS ----------------
  Future<void> _onGetProductsByIds(
    ProductAllByProductIdsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoadingState());
    try {
      final products = await Future.wait(
        event.ids.map((id) => getProductByIdUsecase(id)),
      );

      emit(ProductListByIdsState(products));
    } catch (e) {
      emit(ProductLoadingFailedState(e.toString()));
    }
  }

  /// ---------------- GET COUPONS BY PRODUCT ID ----------------
  Future<void> _onGetAllCoupons(
    ProductCouponGetEvent event,
    Emitter<ProductState> emit,
  ) async {
    final currentState = state;

    // Coupons should update ONLY if product is already loaded
    if (currentState is ProductLoadedState) {
      try {
        final coupons = await getAllCouponsByProductIdUsecase(event.productId);

        // Debug log (optional)
        for (final c in coupons) {
          print('coupon name is ${c.couponName}');
        }

        // ✅ Merge coupons into existing state
        emit(currentState.copyWith(coupons: coupons));
      } catch (e) {
        emit(ProductLoadingFailedState(e.toString()));
      }
    }
  }
}
