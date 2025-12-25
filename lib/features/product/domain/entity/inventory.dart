class Inventory {
  final int id;
  final int productId;
  final int categoryId;
  final int quantity;
  final int availableQuantity;
  final int reservedQuantity;
  final DateTime createdAt;
  final DateTime updatedAt;

  Inventory(
    this.id,
    this.productId,
    this.categoryId,
    this.quantity,
    this.availableQuantity,
    this.reservedQuantity,
    this.createdAt,
    this.updatedAt,
  );
}
