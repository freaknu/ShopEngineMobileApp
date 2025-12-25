import 'package:dio/dio.dart';
import 'package:ecommerce_app/features/auth/data/datasource/local/auth_local_data_source.dart';
import 'package:ecommerce_app/core/auth/auth_interceptor.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late final Dio dio;

  factory ApiClient() => _instance;

  ApiClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: "http://34.58.229.119:8080/",
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(
      AuthInterceptor(
        const AuthLocalDataSource(),
        dio,
      ),
    );
  }
}
