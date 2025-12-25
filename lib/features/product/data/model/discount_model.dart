import 'package:ecommerce_app/features/product/domain/entity/discount.dart';

class DiscountModel extends Discount {
  final String? id;
  final String? couponName;
  final String? couponDescription;
  final double? discountPercentage;
  final String? discountType;
  final String? couponImage;
  final DateTime? validFrom;
  final DateTime? validTill;
  final List<int>? allProductsId;
  DiscountModel(
    this.id,
    this.couponName,
    this.couponDescription,
    this.discountPercentage,
    this.discountType,
    this.couponImage,
    this.validFrom,
    this.validTill,
    this.allProductsId,
  );

  factory DiscountModel.fromJson(Map<String, dynamic> json) => DiscountModel(
    json['id'] as String?,
    json['couponName'] as String?,
    json['couponDescription'] as String?,
    (json['discountPercentage'] as num?)?.toDouble(),
    json['discountType'] as String?,
    json['couponImage'] as String?,
    json['validFrom'] != null ? DateTime.tryParse(json['validFrom']) : null,
    json['validTill'] != null ? DateTime.tryParse(json['validTill']) : null,
    (json['allProductsId'] as List?)?.map((e) => e as int).toList(),
  );
}
