import 'package:ecommerce_app/features/order/domain/entity/order_response.dart';

class OrderresponseModel extends OrderResponse {
  OrderresponseModel({
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

  factory OrderresponseModel.fromJson(Map<String, dynamic> json) {
    return OrderresponseModel(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      productId: json['productId'] ?? 0,
      address: json['address'] != null
          ? Address.fromJson(json['address'])
          : Address(
              id: 0,
              userId: 0,
              addressType: 'HOME',
              name: '',
              email: '',
              address: '',
              city: '',
              state: '',
              landmark: '',
              pinCode: '',
              phoneNumber: '',
              latitude: 0.0,
              longitude: 0.0,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
      orderDate: json['orderDate'] != null ? DateTime.parse(json['orderDate']) : DateTime.now(),
      orderAt: json['orderAt'] != null ? DateTime.parse(json['orderAt']) : DateTime.now(),
      deliveryDate: json['deliveryDate'] != null ? DateTime.parse(json['deliveryDate']) : DateTime.now(),
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      orderStatus: json['orderStatus'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'productId': productId,
      'address': address.toJson(),
      'orderDate': orderDate.toIso8601String(),
      'orderAt': orderAt.toIso8601String(),
      'deliveryDate': deliveryDate.toIso8601String(),
      'discount': discount,
      'orderStatus': orderStatus,
    };
  }
}

extension AddressJsonExtension on Address {
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'addressType': addressType,
      'name': name,
      'email': email,
      'address': address,
      'city': city,
      'state': state,
      'landmark': landmark,
      'pinCode': pinCode,
      'phoneNumber': phoneNumber,
      'latitude': latitude,
      'longitude': longitude,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
