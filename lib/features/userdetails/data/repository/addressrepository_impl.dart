import 'package:ecommerce_app/features/userdetails/data/datasource/remote/address_datasource.dart';
import 'package:ecommerce_app/features/userdetails/data/model/address_model.dart';
import 'package:ecommerce_app/features/userdetails/domain/entity/address.dart';
import 'package:ecommerce_app/features/userdetails/domain/repository/address_repository.dart';

class AddressrepositoryImpl implements AddressRepository {
  final AddressDatasource addressDatasource;
  AddressrepositoryImpl(this.addressDatasource);
  @override
  Future<bool> createAddress(Address address) {
    return addressDatasource.createAddress(
      AddressModel(
        id: address.id,
        userId: address.userId,
        addressType: address.addressType,
        name: address.name,
        email: address.email,
        address: address.address,
        city: address.city,
        state: address.state,
        landmark: address.landmark,
        pinCode: address.pinCode,
        phoneNumber: address.phoneNumber,
        latitude: address.latitude,
        longitude: address.longitude,
        createdAt: address.createdAt,
        updatedAt: address.updatedAt,
      ),
    );
  }

  @override
  Future<bool> delteAddress(int addressId) {
    return addressDatasource.deleteAddress(addressId);
  }

  @override
  Future<List<Address>> getAllAddress() {
    return addressDatasource.getAllAddress();
  }

  @override
  Future<bool> updateAddess(Address address) {
    return addressDatasource.updatedAddress(
      AddressModel(
        id: address.id,
        userId: address.userId,
        addressType: address.addressType,
        name: address.name,
        email: address.email,
        address: address.address,
        city: address.city,
        state: address.state,
        landmark: address.landmark,
        pinCode: address.pinCode,
        phoneNumber: address.phoneNumber,
        latitude: address.latitude,
        longitude: address.longitude,
        createdAt: address.createdAt,
        updatedAt: address.updatedAt,
      ),
    );
  }
}
