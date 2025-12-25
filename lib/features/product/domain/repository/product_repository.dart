import 'package:ecommerce_app/features/product/domain/entity/cart_product.dart';
import 'package:ecommerce_app/features/product/domain/entity/discount.dart';
import 'package:ecommerce_app/features/product/domain/entity/inventory.dart';
import 'package:ecommerce_app/features/product/domain/entity/order_product.dart';
import 'package:ecommerce_app/features/product/domain/entity/order_product_response.dart';
import 'package:ecommerce_app/features/product/domain/entity/product.dart';

abstract class ProductRepository {
  Future<Product> getProductById(int id);
  Future<Inventory> getInventoryByProductId(int id);
  Future<CartProduct> addToCart(CartProduct cartproduct);
  Future<OrderProductResponse> placeOrder(OrderProduct orderProduct);
  Future<List<Discount>> getAllDiscounts(int productId);
}
