class CartProduct {
  final int id;
  final int userId;
  final List<int> productIds;

  CartProduct({
    required this.id,
    required this.userId,
    required this.productIds,
  });
}
