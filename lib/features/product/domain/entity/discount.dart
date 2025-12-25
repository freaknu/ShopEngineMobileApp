class Discount {
  final String? id;
  final String? couponName;
  final String? couponDescription;
  final double? discountPercentage;
  final String? discountType;
  final String? couponImage;
  final DateTime? validFrom;
  final DateTime? validTill;
  final List<int>? allProductsId;

  Discount({
    this.id,
    this.couponName,
    this.couponDescription,
    this.discountPercentage,
    this.discountType,
    this.couponImage,
    this.validFrom,
    this.validTill,
    this.allProductsId,
  });
}