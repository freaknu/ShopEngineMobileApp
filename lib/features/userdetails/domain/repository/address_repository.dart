import 'package:ecommerce_app/features/userdetails/domain/entity/address.dart';

abstract class AddressRepository {
  Future<List<Address>> getAllAddress();
  Future<bool> createAddress(Address address);
  Future<bool> updateAddess(Address address);
  Future<bool> delteAddress(int addressId);
}
