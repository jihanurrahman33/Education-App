import 'package:equatable/equatable.dart';

class TokenRefreshEntity extends Equatable {
  final String refresh;
  final String access;

  const TokenRefreshEntity({
    required this.refresh,
    required this.access,
  });

  @override
  List<Object?> get props => [refresh, access];
}
