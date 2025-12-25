import 'package:ecommerce_app/features/userdetails/domain/entity/address.dart';

class AddressModel extends Address {
  AddressModel({
    int? id,
    int? userId,
    String? addressType,
    String? name,
    String? email,
    String? address,
    String? city,
    String? state,
    String? landmark,
    String? pinCode,
    String? phoneNumber,
    double? latitude,
    double? longitude,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(
          id: id,
          userId: userId,
          addressType: addressType,
          name: name,
          email: email,
          address: address,
          city: city,
          state: state,
          landmark: landmark,
          pinCode: pinCode,
          phoneNumber: phoneNumber,
          latitude: latitude,
          longitude: longitude,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] as int?,
      userId: json['userId'] as int?,
      addressType: json['addressType'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      landmark: json['landmark'] as String?,
      pinCode: json['pinCode'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      latitude: json['latitude'] != null
          ? (json['latitude'] as num).toDouble()
          : null,
      longitude: json['longitude'] != null
          ? (json['longitude'] as num).toDouble()
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (userId != null) 'userId': userId,
      if (addressType != null) 'addressType': addressType,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (address != null) 'address': address,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (landmark != null) 'landmark': landmark,
      if (pinCode != null) 'pinCode': pinCode,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (createdAt != null)
        'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null)
        'updatedAt': updatedAt!.toIso8601String(),
    };
  }
}
