import 'package:dio/dio.dart';
import 'package:ecommerce_app/core/constants/Api/api_endpoints.dart';
import 'package:ecommerce_app/core/constants/Api/app_client.dart';
import 'package:ecommerce_app/features/auth/data/model/auth_response_model.dart';
import 'package:ecommerce_app/features/auth/data/model/create_account_request_model.dart';
import 'package:ecommerce_app/features/auth/data/model/login_account_request_model.dart';
import 'package:ecommerce_app/features/auth/domain/entity/change_password_request.dart';
import 'package:ecommerce_app/features/auth/domain/entity/verifyotp_request.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthApiService {
  final ApiClient _apiClient;

  AuthApiService(this._apiClient);

  // Helper to send FCM token to notification service
  Future<void> _sendFcmToken({
    required int userId,
    required String email,
  }) async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      print("the token is $fcmToken");
      if (fcmToken == null) return;
      final dio = Dio();
      const url = 'http://34.58.229.119:9000/api/notification/addtoken';
      final res = await dio.post(
        url,
        data: {"id": 0, "userId": userId, "fcmToken": fcmToken, "email": email},
      );

      print("the response for add token is $res");
    } catch (e) {
      // Optionally handle/log error
    }
  }

  // ---------------- CREATE ACCOUNT ----------------
  Future<AuthResponseModel> createAccount(
    CreateAccountRequestModel data,
  ) async {
    try {
      final endpoint = ApiEndpoints().createAccount;
      print("the endpoint is $endpoint");
      final res = await _apiClient.dio.post(
        endpoint,
        data: CreateAccountRequestModel.toJson(data),
      );
      // print("the res is $res");
      final ref = await SharedPreferences.getInstance();
      AuthResponseModel response = AuthResponseModel.fromJson(res.data);
      ref.setInt("user_id", response.userId);
      // Send FCM token after signup
      await _sendFcmToken(userId: response.userId, email: data.email);
      return response;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Create account failed');
    }
  }

  // ---------------- LOGIN ----------------
  Future<AuthResponseModel> loginAccount(LoginAccountRequestModel data) async {
    try {
      final endpoint = ApiEndpoints().login;
      final res = await _apiClient.dio.post(
        endpoint,
        data: LoginAccountRequestModel.toJson(data),
      );
      final ref = await SharedPreferences.getInstance();
      AuthResponseModel response = AuthResponseModel.fromJson(res.data);
      ref.setInt("user_id", response.userId);
      // print("the res is $res");
      // Send FCM token after login
      await _sendFcmToken(userId: response.userId, email: data.email);
      return AuthResponseModel.fromJson(res.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Login failed');
    }
  }

  // ---------------- VERIFY OTP ----------------
  Future<String> verifyCode(VerifyotpRequest data) async {
    try {
      final pref = await SharedPreferences.getInstance();
      print("i am. under the verify code ${data.email} and ${data.otp}");
      final endpoint = ApiEndpoints().verifyOtp;

      final res = await _apiClient.dio.post(
        '$endpoint${data.otp}/${data.email}',
      );
      print("the response is $res");
      String tempToken = res.data as String;
      pref.setString('temp_token', tempToken);
      return tempToken;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'OTP verification failed');
    }
  }

  // ---------------- SEND OTP ----------------
  Future<String> sendVerificationCode(String email) async {
    try {
      final endpoint = ApiEndpoints().sendVerifyOtp;

      final res = await _apiClient.dio.post('$endpoint$email');

      return res.data as String;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to send OTP');
    }
  }

  // ---------------- CHANGE PASSWORD ----------------
  Future<String> changePassword(ChangePasswordRequest data) async {
    try {
      final pref = await SharedPreferences.getInstance();
      String token = pref.getString('temp_token') ?? '';
      final endpoint = ApiEndpoints().changePassword;

      final res = await _apiClient.dio.post(
        '$endpoint/$token/${data.newPassword}/${data.email}',
      );

      return res.data as String;
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Password change failed');
    }
  }
}
