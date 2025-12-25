class OrderCreate {
  final int? productId;
  final int? categoryId;
  final int? purchaseQuantity;
   int? userId;
  final int? addressId;
  final double discount;
  OrderCreate({
    required this.productId,
    required this.categoryId,
    required this.purchaseQuantity, this.userId, this.addressId, required this.discount,
  });
}

