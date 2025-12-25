import 'package:ecommerce_app/core/usecase/usecase.dart';
import 'package:ecommerce_app/features/userdetails/domain/entity/address.dart';
import 'package:ecommerce_app/features/userdetails/domain/repository/address_repository.dart';

class CreateaddressUsecase extends Usecase<bool, Address> {
  final AddressRepository addressRepository;
  CreateaddressUsecase(this.addressRepository);
  @override
  Future<bool> call(Address params) {
    return addressRepository.createAddress(params);
  }
}
