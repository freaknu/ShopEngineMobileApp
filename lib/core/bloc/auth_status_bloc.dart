import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_app/features/auth/data/datasource/local/auth_local_data_source.dart';
import 'auth_status_event.dart';
import 'auth_status_state.dart';

class AuthStatusBloc extends Bloc<AuthStatusEvent, AuthStatusState> {
  final AuthLocalDataSource localDataSource;

  AuthStatusBloc(this.localDataSource) : super(AuthStatusInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoggedIn>(_onLoggedIn);
    on<LoggedOut>(_onLoggedOut);
  }

  Future<void> _onAppStarted(
    AppStarted event,
    Emitter<AuthStatusState> emit,
  ) async {
    final token = await localDataSource.getAccessToken();
    emit(token != null ? Authenticated() : Unauthenticated());
  }

  Future<void> _onLoggedIn(
    LoggedIn event,
    Emitter<AuthStatusState> emit,
  ) async {
    emit(Authenticated());
    await Future.delayed(Duration(milliseconds: 100)); // Ensure state is emitted before navigation
  }

  Future<void> _onLoggedOut(
    LoggedOut event,
    Emitter<AuthStatusState> emit,
  ) async {
    await localDataSource.clearTokens();
    emit(Unauthenticated());
    await Future.delayed(Duration(milliseconds: 100)); // Ensure state is emitted before navigation
  }
}
