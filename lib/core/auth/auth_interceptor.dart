import 'package:dio/dio.dart';
import 'package:ecommerce_app/features/auth/data/datasource/local/auth_local_data_source.dart';

class AuthInterceptor extends Interceptor {
  final AuthLocalDataSource localDataSource;
  final Dio dio;

  AuthInterceptor(this.localDataSource, this.dio);

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // Skip auth routes
    if (options.path.contains('/api/auth')) {
      return handler.next(options);
    }

    final token = await localDataSource.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401 ||
        err.requestOptions.path.contains('/api/auth')) {
      return handler.next(err);
    }

    final refreshToken = await localDataSource.getRefreshToken();
    if (refreshToken == null) {
      await localDataSource.clearTokens();
      return handler.reject(err);
    }

    try {
      // 🔥 Use NEW Dio instance (no interceptor)
      final refreshDio = Dio(
        BaseOptions(baseUrl: dio.options.baseUrl),
      );

      final response = await refreshDio.get(
        '/api/auth/getByRefreshToken/$refreshToken',
      );

      final newAccessToken = response.data['accessToken'];

      await localDataSource.saveAccessToken(newAccessToken);

      // Retry original request
      final opts = err.requestOptions;
      opts.headers['Authorization'] = 'Bearer $newAccessToken';

      final cloneReq = await dio.fetch(opts);
      handler.resolve(cloneReq);
    } catch (e) {
      await localDataSource.clearTokens();
      handler.reject(err);
    }
  }
}
