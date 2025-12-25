import 'package:ecommerce_app/features/product/domain/entity/discount.dart';
import 'package:ecommerce_app/features/product/domain/entity/inventory.dart';
import 'package:ecommerce_app/features/product/domain/entity/product.dart';
abstract class ProductState {}

class ProductInitialState extends ProductState {}

class ProductLoadingState extends ProductState {}

class ProductLoadedState extends ProductState {
  final Product product;
  final Inventory inventory;
  final List<Discount>? coupons;
   ProductLoadedState({
    required this.product,
    required this.inventory,
    this.coupons = const [],
  });

  ProductLoadedState copyWith({
    Product? product,
    Inventory? inventory,
    List<Discount>? coupons,
  }) {
    return ProductLoadedState(
      product: product ?? this.product,
      inventory: inventory ?? this.inventory,
      coupons: coupons ?? this.coupons,
    );
  }
}

class ProductLoadingFailedState extends ProductState {
  final String message;
  ProductLoadingFailedState(this.message);
}

class ProductAddToCartState extends ProductState {
  final String message;
  ProductAddToCartState(this.message);
}

class ProductPlacedOrder extends ProductState {
  final String message;
  ProductPlacedOrder(this.message);
}


class ProductListByIdsState extends ProductState {
  final List<Product> allproducts;
  ProductListByIdsState(this.allproducts);
}
