import 'package:equatable/equatable.dart';
import '../../domain/entities/app_settings_entity.dart';

enum SettingsStatus { initial, loading, success, failure }

class SettingsState extends Equatable {
  final SettingsStatus status;
  final AppSettingsEntity settings;
  final String? errorMessage;
  final String? successMessage;

  const SettingsState({
    this.status = SettingsStatus.initial,
    this.settings = const AppSettingsEntity(),
    this.errorMessage,
    this.successMessage,
  });

  SettingsState copyWith({
    SettingsStatus? status,
    AppSettingsEntity? settings,
    String? errorMessage,
    String? successMessage,
    bool clearMessages = false,
  }) {
    return SettingsState(
      status: status ?? this.status,
      settings: settings ?? this.settings,
      errorMessage: clearMessages ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearMessages ? null : (successMessage ?? this.successMessage),
    );
  }

  @override
  List<Object?> get props => [status, settings, errorMessage, successMessage];
}
