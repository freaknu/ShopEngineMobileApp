import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/createaddress_usecase.dart';
import '../../domain/usecases/deleteaddress_usecase.dart';
import '../../domain/usecases/getalladdress_usecase.dart';
import '../../domain/usecases/updateaddress_usecase.dart';
import 'address_event.dart';
import 'address_state.dart';
import '../../../../core/usecase/usecase.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final CreateaddressUsecase createaddressUsecase;
  final DeleteaddressUsecase deleteaddressUsecase;
  final GetalladdressUsecase getalladdressUsecase;
  final UpdateaddressUsecase updateaddressUsecase;

  AddressBloc({
    required this.createaddressUsecase,
    required this.deleteaddressUsecase,
    required this.getalladdressUsecase,
    required this.updateaddressUsecase,
  }) : super(AddressInitial()) {
    on<AddressGetEvent>(_onGetAllAddress);
    on<AddressCreateEvent>(_onCreateAddress);
    on<AddressUpdateEvent>(_onUpdateAddress);
    on<AddressDeleteEvent>(_onDeleteAddress);
  }

  /// ---------------- GET ALL ADDRESSES ----------------
  Future<void> _onGetAllAddress(
    AddressGetEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoadingState());
    try {
      final addresses = await getalladdressUsecase(NoArgs());
      emit(AddressLoadedAllAddress(addresses));
    } catch (e) {
      emit(AddressFailure(e.toString()));
    }
  }

  /// ---------------- CREATE ADDRESS ----------------
  Future<void> _onCreateAddress(
    AddressCreateEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoadingState());
    try {
      print("i am calling");
      await createaddressUsecase(event.address);

      // Emit success state first for UI feedback
      emit(AddressLoadSuccess());
      
      // Then load all addresses for list update
      final addresses = await getalladdressUsecase(NoArgs());
      emit(AddressLoadedAllAddress(addresses));
    } catch (e) {
      emit(AddressFailure(e.toString()));
    }
  }

  /// ---------------- UPDATE ADDRESS ----------------
  Future<void> _onUpdateAddress(
    AddressUpdateEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoadingState());
    try {
      await updateaddressUsecase(event.address);

      final addresses = await getalladdressUsecase(NoArgs());
      emit(AddressLoadedAllAddress(addresses));
    } catch (e) {
      emit(AddressFailure(e.toString()));
    }
  }

  /// ---------------- DELETE ADDRESS ----------------
  Future<void> _onDeleteAddress(
    AddressDeleteEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(AddressLoadingState());
    try {
      await deleteaddressUsecase(event.addressId);

      final addresses = await getalladdressUsecase(NoArgs());
      emit(AddressDeleteState());
      emit(AddressLoadedAllAddress(addresses));
    } catch (e) {
      emit(AddressFailure(e.toString()));
    }
  }
}
