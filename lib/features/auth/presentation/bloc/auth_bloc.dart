import 'package:bloc/bloc.dart';
import 'package:ecommerce_app/core/bloc/auth_status_bloc.dart';
import 'package:ecommerce_app/core/bloc/auth_status_event.dart';
import 'package:ecommerce_app/features/auth/data/datasource/local/auth_local_data_source.dart';
import 'package:ecommerce_app/features/auth/domain/usecase/change_password_usecase.dart';
import 'package:ecommerce_app/features/auth/domain/usecase/create_account_usecase.dart';
import 'package:ecommerce_app/features/auth/domain/usecase/login_account_usecase.dart';
import 'package:ecommerce_app/features/auth/domain/usecase/send_verification_code_usecase.dart';
import 'package:ecommerce_app/features/auth/domain/usecase/verify_otp_usecase.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:ecommerce_app/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginAccountUsecase loginAccountUsecase;
  final CreateAccountUsecase createAccountUsecase;
  final ChangePasswordUsecase changePasswordUsecase;
  final SendVerificationCodeUsecase sendVerificationCodeUsecase;
  final VerifyOtpUsecase verifyOtpUsecase;
  final AuthLocalDataSource storage;
  final AuthStatusBloc authStatusBloc;

  AuthBloc(
    this.storage,
    this.authStatusBloc, {
    required this.loginAccountUsecase,
    required this.createAccountUsecase,
    required this.changePasswordUsecase,
    required this.sendVerificationCodeUsecase,
    required this.verifyOtpUsecase,
  }) : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<SignupEvent>(_onSignup);
    on<SendOtp>(_onSendOtp);
    on<VerifyOtp>(_onVerifyOtp);
    on<ChangePassword>(_onChangePassword);
  }

  // ---------------- LOGIN ----------------
  Future<void> _onLogin(
    LoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading("Logging in..."));
    try {
      final res = await loginAccountUsecase.call(event.data);

      if (res.userId != -1) {
        // Check if user has USER role
        final hasUserRole = res.roles.contains('USER');
        
        if (!hasUserRole) {
          // User doesn't have USER role, reject login
          emit(AuthFailure("Access denied. Only users with USER role can login to this app."));
          return;
        }
        
        // Save tokens only if user has USER role
        await storage.saveTokens(
          accessToken: res.accessToken,
          refreshToken: res.refreshToken,
        );

        authStatusBloc.add(LoggedIn());

        emit(AuthSuccess("Login successful"));
      } else {
        emit(AuthFailure("Login unsuccessful"));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  // ---------------- SIGNUP ----------------
  Future<void> _onSignup(
    SignupEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading("Creating account..."));
    try {
      final res = await createAccountUsecase.call(event.data);

      if (res.userId != -1) {
        // Check if user has USER role
        final hasUserRole = res.roles.contains('USER');
        
        if (!hasUserRole) {
          // User doesn't have USER role, reject signup
          emit(AuthFailure("Access denied. Only users with USER role can access this app."));
          return;
        }
        
        // Save tokens only if user has USER role
        await storage.saveTokens(
          accessToken: res.accessToken,
          refreshToken: res.refreshToken,
        );

        authStatusBloc.add(LoggedIn());

        emit(AuthSuccess("Account created successfully"));
      } else {
        emit(AuthFailure("Account creation failed"));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  // ---------------- SEND OTP ----------------
  Future<void> _onSendOtp(
    SendOtp event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading("Sending OTP..."));
    try {
      await sendVerificationCodeUsecase.call(event.data);
      emit(AuthSuccess("OTP sent successfully"));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  // ---------------- VERIFY OTP ----------------
  Future<void> _onVerifyOtp(
    VerifyOtp event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading("Verifying OTP..."));
    try {
      await verifyOtpUsecase.call(event.data);
      emit(AuthSuccess("OTP verified successfully"));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  // ---------------- CHANGE PASSWORD ----------------
  Future<void> _onChangePassword(
    ChangePassword event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading("Changing password..."));
    try {
      await changePasswordUsecase.call(event.data);
      emit(AuthSuccess("Password changed successfully"));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
