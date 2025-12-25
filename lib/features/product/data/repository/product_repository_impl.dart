import 'package:ecommerce_app/features/product/data/datasource/remote/product_api_service.dart';
import 'package:ecommerce_app/features/product/data/model/cartproduct_model.dart';
import 'package:ecommerce_app/features/product/data/model/orderproduct_model.dart';
import 'package:ecommerce_app/features/product/domain/entity/cart_product.dart';
import 'package:ecommerce_app/features/product/domain/entity/discount.dart';
import 'package:ecommerce_app/features/product/domain/entity/inventory.dart';
import 'package:ecommerce_app/features/product/domain/entity/order_product.dart';
import 'package:ecommerce_app/features/product/domain/entity/order_product_response.dart';
import 'package:ecommerce_app/features/product/domain/entity/product.dart';
import 'package:ecommerce_app/features/product/domain/repository/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductApiService _apiService;
  ProductRepositoryImpl(this._apiService);
  @override
  Future<Product> getProductById(int id) {
    return _apiService.getProductByProductId(id);
  }

  @override
  Future<Inventory> getInventoryByProductId(int id) {
    return _apiService.getInventoryByProductId(id);
  }

  @override
  Future<CartProduct> addToCart(CartProduct cartproduct) async {
    final res = await _apiService.addToCart(
      CartproductModel(
        id: cartproduct.id,
        userId: cartproduct.userId,
        productIds: cartproduct.productIds,
      ),
    );

    return CartProduct(
      id: res?.id ?? -1,
      userId: res?.userId ?? -1,
      productIds: res?.productIds ?? [],
    );
  }

  @override
  Future<OrderProductResponse> placeOrder(OrderProduct orderProduct) async {
    final res = await _apiService.orderProduct(
      OrderproductModel(
        orderProduct.productId,
        orderProduct.categoryId,
        orderProduct.purachaseQuantity,
        orderProduct.userId,
        orderProduct.addressId,
        orderProduct.discount,
      )
    );

    return OrderProductResponse(
      id: res?.id ?? -1,
      userId: res?.userId ?? -1,
      productId: res?.productId ?? -1,
      address: res!.address,
      orderDate: res.orderDate,
      orderAt: res.orderAt,
      deliveryDate: res.deliveryDate,
      discount: res.discount,
      orderStatus: res.orderStatus,
    );
  }

  @override
  Future<List<Discount>> getAllDiscounts(int productId) {
    return _apiService.getAllDiscounts(productId);
  }
}
