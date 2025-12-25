import 'package:ecommerce_app/features/product/domain/entity/product.dart';

abstract class CartEvent {}

class CartDataGet extends CartEvent {}

class CartDataDelete extends CartEvent {
  final int productId;
  CartDataDelete(this.productId);
}

class CartDataClear extends CartEvent {
  List<Product> allProducts;
  CartDataClear(this.allProducts);
}
