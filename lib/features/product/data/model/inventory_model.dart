import 'package:ecommerce_app/features/product/domain/entity/inventory.dart';

class InventoryModel extends Inventory {
  InventoryModel(
    super.id,
    super.productId,
    super.categoryId,
    super.quantity,
    super.availableQuantity,
    super.reservedQuantity,
    super.createdAt,
    super.updatedAt,
  );

  factory InventoryModel.fromJson(Map<String, dynamic> data) {
    return InventoryModel(
      data['id'] as int,
      data['productId'] as int,
      data['categoryId'] as int,
      data['quantity'] as int,
      data['availableQuantity'] as int,
      data['reservedQuantity'] as int,
      DateTime.parse(data['createdAt']),
      data['updatedAt'] != null ? DateTime.parse(data['updatedAt']) : DateTime.parse(data['createdAt']),
    );
  }
}
