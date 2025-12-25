import 'package:ecommerce_app/core/usecase/usecase.dart';
import 'package:ecommerce_app/features/order/domain/usecase/cancelorder_usecase.dart';
import 'package:ecommerce_app/features/order/domain/usecase/getallorders_usecase.dart';
import 'package:ecommerce_app/features/order/domain/usecase/orderplace_usecase.dart';
import 'package:ecommerce_app/features/order/presentation/bloc/order_event.dart';
import 'package:ecommerce_app/features/order/presentation/bloc/order_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final GetallordersUsecase orderUsecase;
  final CancelorderUsecase cancelorderUsecase;
  final OrderplaceUsecase orderplaceUsecase;
  OrderBloc(this.orderUsecase, this.cancelorderUsecase, this.orderplaceUsecase)
    : super(OrderIntialState()) {
    on<OrderGetAllEvent>(_onorderGetAll);
    on<OrderPlaceEvent>(_onOrderPlace);
    on<OrderCancelEvent>(_onCancelOrder);
  }

  Future<void> _onorderGetAll(
    OrderGetAllEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoadingState());
    try {
      final res = await orderUsecase(NoArgs());
      emit(AllOrderLoadedState(res));
    } catch (e) {
      emit(OrderFailedState());
    }
  }

  Future<void> _onOrderPlace(
    OrderPlaceEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoadingState());
    try {
      final res = await orderplaceUsecase(
        event.data
      );

      emit(OrderPlacedState(res));
    } catch (e) {
      emit(OrderFailedState());
    }
  }

  Future<void> _onCancelOrder(
    OrderCancelEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoadingState());
    try {
      final res = await cancelorderUsecase(event.orderId);
      emit(OrderPlacedState(res));
    } catch (e) {
      emit(OrderFailedState());
    }
  }
}
