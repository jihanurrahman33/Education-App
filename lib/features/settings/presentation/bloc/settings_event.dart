import 'package:equatable/equatable.dart';
import '../../domain/entities/app_settings_entity.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSettingsEvent extends SettingsEvent {
  const LoadSettingsEvent();
}

class UpdateSettingsEvent extends SettingsEvent {
  final AppSettingsEntity settings;

  const UpdateSettingsEvent(this.settings);

  @override
  List<Object?> get props => [settings];
}

class ToggleDarkModeEvent extends SettingsEvent {
  final bool isDarkMode;

  const ToggleDarkModeEvent(this.isDarkMode);

  @override
  List<Object?> get props => [isDarkMode];
}

class TogglePushNotificationsEvent extends SettingsEvent {
  final bool enabled;

  const TogglePushNotificationsEvent(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

class ToggleEmailNotificationsEvent extends SettingsEvent {
  final bool enabled;

  const ToggleEmailNotificationsEvent(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

class ToggleWifiDownloadEvent extends SettingsEvent {
  final bool enabled;

  const ToggleWifiDownloadEvent(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

class ChangeLanguageEvent extends SettingsEvent {
  final String languageCode;

  const ChangeLanguageEvent(this.languageCode);

  @override
  List<Object?> get props => [languageCode];
}
