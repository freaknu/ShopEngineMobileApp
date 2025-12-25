import 'package:ecommerce_app/features/notification/domain/usecase/get_all_notifications_usecase.dart';
import 'package:ecommerce_app/features/notification/presentation/bloc/notification_event.dart';
import 'package:ecommerce_app/features/notification/presentation/bloc/notification_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetAllNotificationsUsecase getAllNotificationsUsecase;

  NotificationBloc({
    required this.getAllNotificationsUsecase,
  }) : super(NotificationInitialState()) {
    on<GetAllNotificationsEvent>(_onGetAllNotifications);
  }

  Future<void> _onGetAllNotifications(
    GetAllNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoadingState());
    try {
      final notifications = await getAllNotificationsUsecase();
      emit(NotificationLoadedState(notifications));
    } catch (e) {
      emit(NotificationErrorState(e.toString()));
    }
  }

 
}
