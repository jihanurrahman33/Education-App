class AppConstants {
  const AppConstants._();

  static const String appName = 'Education App';

  // Storage keys
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';
  static const String userRoleKey = 'user_role';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // Pagination defaults
  static const int defaultPageSize = 10;
}
