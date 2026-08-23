import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? code;

  const Failure({
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];
}

/// Remote backend or API failure
class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code});
}

/// Connectivity or socket timeout failure
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'Please check your internet connection.',
    super.code,
  });
}

/// Local storage / Cache failure
class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Failed to load or save cached data.',
    super.code,
  });
}

/// User input validation or domain invariant violation
class ValidationFailure extends Failure {
  const ValidationFailure({required super.message, super.code});
}

/// Authentication / Token failure
class AuthenticationFailure extends Failure {
  const AuthenticationFailure({
    super.message = 'Session expired or unauthorized. Please log in again.',
    super.code = 401,
  });
}

/// Fallback failure for unexpected errors
class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'An unexpected error occurred. Please try again.',
    super.code,
  });
}
