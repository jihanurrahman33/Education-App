import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_endpoints.dart';
import '../constants/app_constants.dart';
import '../error/exceptions.dart';

class ApiClient {
  final Dio dio;
  final SharedPreferences prefs;

  ApiClient({
    required this.dio,
    required this.prefs,
  }) {
    dio.options = BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: AppConstants.connectTimeout,
      receiveTimeout: AppConstants.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = prefs.getString(AppConstants.tokenKey);
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401 &&
              !e.requestOptions.path.contains('/auth/login') &&
              !e.requestOptions.path.contains('/auth/refresh') &&
              !e.requestOptions.path.contains('/auth/token/refresh')) {
            final refreshToken = prefs.getString(AppConstants.refreshTokenKey);
            if (refreshToken != null && refreshToken.isNotEmpty) {
              try {
                final refreshDio = Dio(
                  BaseOptions(
                    baseUrl: ApiEndpoints.baseUrl,
                    headers: {'Content-Type': 'application/json'},
                  ),
                );
                final res = await refreshDio.post(
                  ApiEndpoints.refreshToken,
                  data: {'refresh': refreshToken},
                );

                if (res.data is Map<String, dynamic> && res.data['access'] != null) {
                  final newAccess = res.data['access'].toString();
                  await prefs.setString(AppConstants.tokenKey, newAccess);

                  if (res.data['refresh'] != null) {
                    await prefs.setString(
                      AppConstants.refreshTokenKey,
                      res.data['refresh'].toString(),
                    );
                  }

                  // Retry the original request with new access token
                  e.requestOptions.headers['Authorization'] = 'Bearer $newAccess';
                  final retryRes = await dio.fetch(e.requestOptions);
                  return handler.resolve(retryRes);
                }
              } catch (_) {
                // If refresh token has expired, purge invalid tokens
                await prefs.remove(AppConstants.tokenKey);
                await prefs.remove(AppConstants.refreshTokenKey);
              }
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Future<dynamic> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Future<dynamic> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Future<dynamic> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Never _handleDioError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError) {
      final detail = error.error?.toString() ?? error.message ?? 'Server unreachable';
      throw NetworkException(
        message: 'Network connection timeout or unreachable ($detail). Please check internet and rebuild app.',
      );
    }

    final statusCode = error.response?.statusCode;
    final responseData = error.response?.data;

    String errorMessage = 'A server error occurred.';
    if (responseData is Map<String, dynamic>) {
      if (responseData['detail'] != null) {
        errorMessage = responseData['detail'].toString();
      } else if (responseData['message'] != null) {
        errorMessage = responseData['message'].toString();
      } else if (responseData['error'] != null) {
        errorMessage = responseData['error'].toString();
      } else if (responseData.entries.isNotEmpty) {
        final entry = responseData.entries.first;
        final key = entry.key;
        final val = entry.value;
        if (val is List && val.isNotEmpty) {
          errorMessage = '$key: ${val.first}';
        } else {
          errorMessage = '$key: $val';
        }
      } else if (error.message != null) {
        errorMessage = error.message!;
      }
    } else if (responseData is String && responseData.isNotEmpty) {
      errorMessage = responseData;
    } else if (error.message != null) {
      errorMessage = error.message!;
    }

    if (statusCode == 401) {
      throw UnauthorizedException(message: errorMessage);
    }

    throw ServerException(
      message: errorMessage,
      statusCode: statusCode,
    );
  }
}
