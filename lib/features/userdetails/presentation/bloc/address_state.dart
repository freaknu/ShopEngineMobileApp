import '../../domain/entity/address.dart';

abstract class AddressState {}

class AddressInitial extends AddressState {}

class AddressLoadingState extends AddressState {}

class AddressLoadedAllAddress extends AddressState {
  final List<Address> allAddress;
  AddressLoadedAllAddress(this.allAddress);
}

class AddressFailure extends AddressState {
  final String message;
  AddressFailure(this.message);
}

class AddressLoadSuccess extends AddressState {}

class AddressDeleteState extends AddressState{}