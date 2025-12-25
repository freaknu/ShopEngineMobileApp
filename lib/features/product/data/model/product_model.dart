import 'package:ecommerce_app/features/product/domain/entity/product.dart';

class ProductModel extends Product {
  ProductModel({
    required super.id,
    required super.productName,
    required super.productDescription,
    required super.productPrice,
    required super.productsImages,
    required super.categoryName,
    required super.categoryId,
    required super.sizes
  });

  factory ProductModel.fromJson(Map<String, dynamic> data) {
    return ProductModel(
      id: data['id'] as int,
      productName: data['productName'] as String,
      productDescription: data['productDescription'] as String,
      productPrice: (data['productPrice'] as num).toDouble(),
      productsImages: List<String>.from(data['productsImages'] ?? []),
      sizes: List<String>.from(data['sizes'] ?? []),
      categoryName: data['categoryName'] as String,
      categoryId: data['categoryId'] as int,
    );
  }
}
