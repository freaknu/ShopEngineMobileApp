import 'package:ecommerce_app/features/product/domain/entity/order_product.dart';

class OrderproductModel extends OrderProduct {
  OrderproductModel(
    super.productId,
    super.categoryId,
    super.purachaseQuantity,
    super.userId,
    super.addressId,
    super.discount,
  );

  factory OrderproductModel.fromJson(Map<String, dynamic> json) {
    return OrderproductModel(
      json['productId'] ?? 0,
      json['categoryId'] ?? 0,
      json['purchaseQuantity'] ?? 0,
      json['userId'] ?? 0,
      json['addressId'] ?? 0,
      json['discount'] != null ? (json['discount'] as num).toDouble() : 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'categoryId': categoryId,
      'purchaseQuantity': purachaseQuantity,
      'userId': userId,
      'addressId': addressId,
      'discount': discount,
    };
  }
}
