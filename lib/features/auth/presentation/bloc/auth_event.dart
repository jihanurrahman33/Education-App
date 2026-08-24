import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

class AuthLoginSubmitted extends AuthEvent {
  final String usernameOrEmail;
  final String password;

  const AuthLoginSubmitted({
    required this.usernameOrEmail,
    required this.password,
  });

  @override
  List<Object?> get props => [usernameOrEmail, password];
}

class AuthRegisterSubmitted extends AuthEvent {
  final String username;
  final String email;
  final String password;
  final UserRole role;
  final String? firstName;
  final String? lastName;
  final String? phone;

  const AuthRegisterSubmitted({
    required this.username,
    required this.email,
    required this.password,
    required this.role,
    this.firstName,
    this.lastName,
    this.phone,
  });

  @override
  List<Object?> get props => [username, email, password, role, firstName, lastName, phone];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}
