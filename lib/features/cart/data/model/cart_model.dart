import 'package:ecommerce_app/features/cart/domain/entity/cart.dart';

class CartModel extends Cart {
  CartModel({
    required super.id,
    required super.userId,
    required super.productIds,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'] as int,
      userId: json['userId'] as int,
      productIds: (json['productIds'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'userId': userId, 'productIds': productIds};
  }
}
