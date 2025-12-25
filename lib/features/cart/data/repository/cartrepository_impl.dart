import 'package:ecommerce_app/features/cart/data/datasource/remote/cart_datasource.dart';
import 'package:ecommerce_app/features/cart/domain/entity/cart.dart';
import 'package:ecommerce_app/features/cart/domain/repository/cart_repository.dart';

class CartrepositoryImpl implements CartRepository {
  final CartDatasource cartDatasource;
  CartrepositoryImpl(this.cartDatasource);

  @override
  Future<bool> deleteFromCart(int productId) {
    return cartDatasource.deleteFromCart(productId);
  }

  @override
  Future<Cart> getAllCarts() async {
    print("under get all carts impl");
    final cartModel = await cartDatasource.getAllCarts();
    if (cartModel == null) {
      throw Exception('Cart not found');
    }
    return cartModel;
  }
}
