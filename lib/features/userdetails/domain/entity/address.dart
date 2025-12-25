class Address {
  final int? id;
   int? userId;
  final String? addressType;
  final String? name;
  final String? email;
  final String? address;
  final String? city;
  final String? state;
  final String? landmark;
  final String? pinCode;
  final String? phoneNumber;
  final double? latitude;
  final double? longitude;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Address({
    this.id,
    this.userId,
    this.addressType,
    this.name,
    this.email,
    this.address,
    this.city,
    this.state,
    this.landmark,
    this.pinCode,
    this.phoneNumber,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.updatedAt,
  });
}
