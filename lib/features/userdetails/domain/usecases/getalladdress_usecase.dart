import 'package:ecommerce_app/core/usecase/usecase.dart';
import 'package:ecommerce_app/features/userdetails/domain/entity/address.dart';
import 'package:ecommerce_app/features/userdetails/domain/repository/address_repository.dart';

class GetalladdressUsecase extends Usecase<List<Address>, NoArgs> {
  final AddressRepository addressRepository;
  GetalladdressUsecase(this.addressRepository);
  @override
  Future<List<Address>> call(NoArgs params) {
    return addressRepository.getAllAddress();
  }
}
