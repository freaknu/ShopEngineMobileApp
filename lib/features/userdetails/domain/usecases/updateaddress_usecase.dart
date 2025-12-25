import 'package:ecommerce_app/core/usecase/usecase.dart';
import 'package:ecommerce_app/features/userdetails/domain/entity/address.dart';
import 'package:ecommerce_app/features/userdetails/domain/repository/address_repository.dart';

class UpdateaddressUsecase extends Usecase<bool, Address> {
  final AddressRepository addressRepository;
  UpdateaddressUsecase(this.addressRepository);
  @override
  Future<bool> call(Address params) {
    return addressRepository.updateAddess(params);
  }
}
