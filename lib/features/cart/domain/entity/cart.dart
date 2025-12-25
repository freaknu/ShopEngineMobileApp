class Cart {
  final int id;
  final int userId;
  final List<int> productIds;

  Cart({
    required this.id,
    required this.userId,
    required this.productIds,
  });
}
