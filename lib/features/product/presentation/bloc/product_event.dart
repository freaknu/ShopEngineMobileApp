import 'package:ecommerce_app/features/product/domain/entity/cart_product.dart';
import 'package:ecommerce_app/features/product/domain/entity/order_product.dart';

abstract class ProductEvent {}

class GetProductByIdEvent extends ProductEvent {
  final int id;
  GetProductByIdEvent(this.id);
}

class GetProductInventoryEvent extends ProductEvent {
  final int id;
  GetProductInventoryEvent(this.id);
}

class ProductOrderPlaceEvent extends ProductEvent {
  final OrderProduct orderProduct;

  ProductOrderPlaceEvent(this.orderProduct);
}

class ProductAddToCartEvent extends ProductEvent {
  final CartProduct cartProduct;

  ProductAddToCartEvent(this.cartProduct);
}

class ProductAllByProductIdsEvent extends ProductEvent {
  final List<int> ids;
  ProductAllByProductIdsEvent(this.ids);
}

class ProductCouponGetEvent extends ProductEvent {
  final int productId;
  ProductCouponGetEvent(this.productId);
}

class ProductReviewEvent extends ProductEvent {
  final int productId;
  ProductReviewEvent(this.productId);
}
