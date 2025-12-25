class Address {
  final int id;
  final int userId;
  final String addressType;
  final String name;
  final String email;
  final String address;
  final String city;
  final String state;
  final String landmark;
  final String pinCode;
  final String phoneNumber;
  final double latitude;
  final double longitude;
  final DateTime createdAt;
  final DateTime updatedAt;

  Address({
    required this.id,
    required this.userId,
    required this.addressType,
    required this.name,
    required this.email,
    required this.address,
    required this.city,
    required this.state,
    required this.landmark,
    required this.pinCode,
    required this.phoneNumber,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt,
  });

  static Address fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      addressType: json['addressType'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      landmark: json['landmark'] ?? '',
      pinCode: json['pinCode'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
    );
  }
}

class OrderResponse {
  final int id;
  final int userId;
  final int productId;
  final Address address;
  final DateTime orderDate;
  final DateTime orderAt;
  final DateTime deliveryDate;
  final double discount;
  final String orderStatus;

  OrderResponse({
    required this.id,
    required this.userId,
    required this.productId,
    required this.address,
    required this.orderDate,
    required this.orderAt,
    required this.deliveryDate,
    required this.discount,
    required this.orderStatus,
  });
}