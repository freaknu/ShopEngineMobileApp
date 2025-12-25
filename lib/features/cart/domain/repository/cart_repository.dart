import 'package:ecommerce_app/features/cart/domain/entity/cart.dart';

abstract class CartRepository {
  Future<Cart>  getAllCarts();
  Future<bool> deleteFromCart(int productId);
}