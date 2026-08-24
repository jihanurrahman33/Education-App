import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/networking/api_client.dart';
import '../../domain/entities/user_entity.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String usernameOrEmail,
    required String password,
  });

  Future<UserModel> register({
    required String username,
    required String email,
    required String password,
    required UserRole role,
    String? firstName,
    String? lastName,
  });

  Future<UserModel> getCurrentUser();

  Future<String> refreshToken(String refreshToken);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  const AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<UserModel> login({
    required String usernameOrEmail,
    required String password,
  }) async {
    final response = await apiClient.post(
      ApiEndpoints.login,
      data: {
        'username': usernameOrEmail,
        'password': password,
      },
    );

    if (response is Map<String, dynamic>) {
      final userJson = response['user'] is Map<String, dynamic>
          ? response['user'] as Map<String, dynamic>
          : response;

      final token = response['access'] ?? response['token'] ?? '';
      final refreshToken = response['refresh'] ?? response['refresh_token'] ?? '';

      final model = UserModel.fromJson(userJson).copyWith(
        token: token.toString(),
        refreshToken: refreshToken.toString(),
      );
      return model;
    }

    throw Exception('Invalid login response format');
  }

  @override
  Future<UserModel> register({
    required String username,
    required String email,
    required String password,
    required UserRole role,
    String? firstName,
    String? lastName,
  }) async {
    final response = await apiClient.post(
      ApiEndpoints.register,
      data: {
        'username': username,
        'email': email,
        'password': password,
        'role': role.toApiValue(),
        'first_name': ?firstName,
        'last_name': ?lastName,
      },
    );

    if (response is Map<String, dynamic>) {
      final userJson = response['user'] is Map<String, dynamic>
          ? response['user'] as Map<String, dynamic>
          : response;

      return UserModel.fromJson(userJson);
    }

    throw Exception('Invalid register response format');
  }

  @override
  Future<UserModel> getCurrentUser() async {
    final response = await apiClient.get(ApiEndpoints.currentUser);

    if (response is Map<String, dynamic>) {
      return UserModel.fromJson(response);
    }

    throw Exception('Invalid current user response format');
  }

  @override
  Future<String> refreshToken(String refreshToken) async {
    final response = await apiClient.post(
      ApiEndpoints.refreshToken,
      data: {'refresh': refreshToken},
    );

    if (response is Map<String, dynamic> && response['access'] != null) {
      return response['access'].toString();
    }

    throw Exception('Failed to refresh token');
  }
}
