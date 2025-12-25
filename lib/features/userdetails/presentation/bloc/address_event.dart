import '../../domain/entity/address.dart';

abstract class AddressEvent {}

class AddressGetEvent extends AddressEvent {}

class AddressCreateEvent extends AddressEvent {
  final Address address;
  AddressCreateEvent(this.address);
}

class AddressUpdateEvent extends AddressEvent {
  final Address address;
  AddressUpdateEvent(this.address);
}

class AddressDeleteEvent extends AddressEvent {
  final int addressId;
  AddressDeleteEvent(this.addressId);
}
