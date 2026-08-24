import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/app_settings_entity.dart';
import '../../domain/usecases/get_settings_use_case.dart';
import '../../domain/usecases/save_settings_use_case.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetSettingsUseCase getSettingsUseCase;
  final SaveSettingsUseCase saveSettingsUseCase;

  SettingsBloc({
    required this.getSettingsUseCase,
    required this.saveSettingsUseCase,
  }) : super(const SettingsState()) {
    on<LoadSettingsEvent>(_onLoadSettings);
    on<UpdateSettingsEvent>(_onUpdateSettings);
    on<ToggleDarkModeEvent>(_onToggleDarkMode);
    on<TogglePushNotificationsEvent>(_onTogglePushNotifications);
    on<ToggleEmailNotificationsEvent>(_onToggleEmailNotifications);
    on<ToggleWifiDownloadEvent>(_onToggleWifiDownload);
    on<ChangeLanguageEvent>(_onChangeLanguage);
  }

  Future<void> _onLoadSettings(
    LoadSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(status: SettingsStatus.loading));

    final result = await getSettingsUseCase(const NoParams());

    result.fold(
      (failure) => emit(state.copyWith(
        status: SettingsStatus.failure,
        errorMessage: failure.message,
      )),
      (settings) => emit(state.copyWith(
        status: SettingsStatus.success,
        settings: settings,
      )),
    );
  }

  Future<void> _saveAndEmit(
    AppSettingsEntity newSettings,
    Emitter<SettingsState> emit, {
    String? message,
  }) async {
    emit(state.copyWith(settings: newSettings, status: SettingsStatus.loading));

    final result = await saveSettingsUseCase(newSettings);

    result.fold(
      (failure) => emit(state.copyWith(
        status: SettingsStatus.failure,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(
        status: SettingsStatus.success,
        settings: newSettings,
        successMessage: message,
      )),
    );
  }

  Future<void> _onUpdateSettings(
    UpdateSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    await _saveAndEmit(event.settings, emit, message: 'Settings saved successfully');
  }

  Future<void> _onToggleDarkMode(
    ToggleDarkModeEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final updated = state.settings.copyWith(isDarkMode: event.isDarkMode);
    await _saveAndEmit(updated, emit);
  }

  Future<void> _onTogglePushNotifications(
    TogglePushNotificationsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final updated = state.settings.copyWith(pushNotificationsEnabled: event.enabled);
    await _saveAndEmit(updated, emit);
  }

  Future<void> _onToggleEmailNotifications(
    ToggleEmailNotificationsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final updated = state.settings.copyWith(emailNotificationsEnabled: event.enabled);
    await _saveAndEmit(updated, emit);
  }

  Future<void> _onToggleWifiDownload(
    ToggleWifiDownloadEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final updated = state.settings.copyWith(downloadOverWifiOnly: event.enabled);
    await _saveAndEmit(updated, emit);
  }

  Future<void> _onChangeLanguage(
    ChangeLanguageEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final updated = state.settings.copyWith(selectedLanguage: event.languageCode);
    await _saveAndEmit(updated, emit, message: 'Language updated');
  }
}
