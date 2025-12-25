import 'package:ecommerce_app/core/usecase/usecase.dart';
import 'package:ecommerce_app/features/userdetails/domain/repository/address_repository.dart';

class DeleteaddressUsecase extends Usecase<bool, int> {
  final AddressRepository addressRepository;
  DeleteaddressUsecase(this.addressRepository);
  @override
  Future<bool> call(int params) {
    return addressRepository.delteAddress(params);
  }
}
