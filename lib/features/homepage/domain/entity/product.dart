class Product {
  final int id;
  final String productName;
  final String productDescription;
  final double productPrice;
  final List<String> productsImages;
  final String categoryName;
  final int categoryId;

  Product({
    required this.id,
    required this.productName,
    required this.productDescription,
    required this.productPrice,
    required this.productsImages,
    required this.categoryName,
    required this.categoryId,
  });
}