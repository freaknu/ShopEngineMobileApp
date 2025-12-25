import 'package:ecommerce_app/features/product/domain/entity/cart_product.dart';

class CartproductModel extends CartProduct {
  CartproductModel({required super.id, required super.userId, required super.productIds});

  factory CartproductModel.fromJson(Map<String, dynamic> json) {
    return CartproductModel(
      id: json['id'] as int,
      userId: json['userId'] as int,
      productIds: (json['productIds'] as List<dynamic>).map((e) => e as int).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'productIds': productIds,
    };
  }
}