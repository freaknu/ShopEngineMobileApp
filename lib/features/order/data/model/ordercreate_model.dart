import 'package:ecommerce_app/features/order/domain/entity/order_create.dart';

class OrdercreateModel extends OrderCreate {
  OrdercreateModel({
    required super.productId,
    required super.categoryId,
    required super.purchaseQuantity,
    super.userId,
    super.addressId,
    required super.discount,
  });

  factory OrdercreateModel.fromJson(Map<String, dynamic> json) {
    return OrdercreateModel(
      productId: json['productId'] as int?,
      categoryId: json['categoryId'] as int?,
      purchaseQuantity: json['purchaseQuantity'] as int?,
      userId: json['userId'] as int?,
      addressId: json['addressId'] as int?,
      discount: json['discount'] != null
          ? (json['discount'] as num).toDouble()
          : 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'categoryId': categoryId,
      'purchaseQuantity': purchaseQuantity,
      'userId': userId,
      'addressId': addressId,
      'discount': discount,
    };
  }
}