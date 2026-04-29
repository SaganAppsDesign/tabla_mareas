import 'package:dio/dio.dart';

class DioClient {
  DioClient(this._dio) {
    _dio.options = BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      responseType: ResponseType.json,
    );

    _dio.interceptors.add(
      LogInterceptor(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Here you can inject security tokens from SecureStorageService
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          // Map DioException to custom Failure
          return handler.next(e);
        },
      ),
    );
  }
  final Dio _dio;

  Dio get dio => _dio;
}
