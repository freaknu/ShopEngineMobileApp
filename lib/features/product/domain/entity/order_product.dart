class OrderProduct {
  final int productId;
  final int categoryId;
  final int purachaseQuantity;
  int userId;
  final int addressId;
  final double discount;

  OrderProduct(
    this.productId,
    this.categoryId,
    this.purachaseQuantity,
    this.userId,
    this.addressId,
    this.discount,
  );
}
