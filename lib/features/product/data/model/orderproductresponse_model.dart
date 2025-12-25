import 'package:ecommerce_app/features/product/domain/entity/order_product_response.dart';

class OrderproductresponseModel extends OrderProductResponse {
  OrderproductresponseModel({
    required super.id,
    required super.userId,
    required super.productId,
    required super.address,
    required super.orderDate,
    required super.orderAt,
    required super.deliveryDate,
    required super.discount,
    required super.orderStatus,
  });

  factory OrderproductresponseModel.fromJson(Map<String, dynamic> json) {
    return OrderproductresponseModel(
      id: json['id'] as int,
      userId: json['userId'] as int,
      productId: json['productId'] as int,
      address: Address(
        id: json['address']['id'] as int,
        userId: json['address']['userId'] as int,
        addressType: json['address']['addressType'] as String,
        name: json['address']['name'] as String,
        email: json['address']['email'] as String,
        address: json['address']['address'] as String,
        city: json['address']['city'] as String,
        state: json['address']['state'] as String,
        landmark: json['address']['landmark'] as String,
        pinCode: json['address']['pinCode'] as String,
        phoneNumber: json['address']['phoneNumber'] as String,
        latitude: (json['address']['latitude'] as num).toDouble(),
        longitude: (json['address']['longitude'] as num).toDouble(),
        createdAt: DateTime.parse(json['address']['createdAt'] as String),
        updatedAt: DateTime.parse(json['address']['updatedAt'] as String),
      ),
      orderDate: DateTime.parse(json['orderDate'] as String),
      orderAt: DateTime.parse(json['orderAt'] as String),
      deliveryDate: DateTime.parse(json['deliveryDate'] as String),
      discount: (json['discount'] as num).toDouble(),
      orderStatus: json['orderStatus'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'productId': productId,
      'address': {
        'id': address.id,
        'userId': address.userId,
        'addressType': address.addressType,
        'name': address.name,
        'email': address.email,
        'address': address.address,
        'city': address.city,
        'state': address.state,
        'landmark': address.landmark,
        'pinCode': address.pinCode,
        'phoneNumber': address.phoneNumber,
        'latitude': address.latitude,
        'longitude': address.longitude,
        'createdAt': address.createdAt.toIso8601String(),
        'updatedAt': address.updatedAt.toIso8601String(),
      },
      'orderDate': orderDate.toIso8601String(),
      'orderAt': orderAt.toIso8601String(),
      'deliveryDate': deliveryDate.toIso8601String(),
      'discount': discount,
      'orderStatus': orderStatus,
    };
  }
}
