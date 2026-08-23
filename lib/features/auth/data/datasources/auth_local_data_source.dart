import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheAuthToken(String token);
  Future<String?> getAuthToken();
  Future<void> cacheRefreshToken(String refreshToken);
  Future<String?> getRefreshToken();
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearSession();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences _prefs;

  const AuthLocalDataSourceImpl({required SharedPreferences prefs}) : _prefs = prefs;

  @override
  Future<void> cacheAuthToken(String token) async {
    try {
      await _prefs.setString(AppConstants.tokenKey, token);
    } catch (e) {
      throw CacheException(message: 'Failed to cache authentication token: $e');
    }
  }

  @override
  Future<String?> getAuthToken() async {
    try {
      return _prefs.getString(AppConstants.tokenKey);
    } catch (e) {
      throw CacheException(message: 'Failed to read cached token: $e');
    }
  }

  @override
  Future<void> cacheRefreshToken(String refreshToken) async {
    try {
      await _prefs.setString(AppConstants.refreshTokenKey, refreshToken);
    } catch (e) {
      throw CacheException(message: 'Failed to cache refresh token: $e');
    }
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      return _prefs.getString(AppConstants.refreshTokenKey);
    } catch (e) {
      throw CacheException(message: 'Failed to read refresh token: $e');
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      final userJson = jsonEncode(user.toJson());
      await _prefs.setString(AppConstants.userDataKey, userJson);
      await _prefs.setString(AppConstants.userRoleKey, user.role.toApiValue());
    } catch (e) {
      throw CacheException(message: 'Failed to cache user profile: $e');
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final userString = _prefs.getString(AppConstants.userDataKey);
      if (userString != null && userString.isNotEmpty) {
        final Map<String, dynamic> json = jsonDecode(userString);
        return UserModel.fromJson(json);
      }
      return null;
    } catch (e) {
      throw CacheException(message: 'Failed to retrieve cached user: $e');
    }
  }

  @override
  Future<void> clearSession() async {
    try {
      await _prefs.remove(AppConstants.tokenKey);
      await _prefs.remove(AppConstants.refreshTokenKey);
      await _prefs.remove(AppConstants.userDataKey);
      await _prefs.remove(AppConstants.userRoleKey);
    } catch (e) {
      throw CacheException(message: 'Failed to clear session: $e');
    }
  }
}
