import 'package:equatable/equatable.dart';

class AppSettingsEntity extends Equatable {
  final bool isDarkMode;
  final bool pushNotificationsEnabled;
  final bool emailNotificationsEnabled;
  final bool downloadOverWifiOnly;
  final String selectedLanguage;

  const AppSettingsEntity({
    this.isDarkMode = false,
    this.pushNotificationsEnabled = true,
    this.emailNotificationsEnabled = true,
    this.downloadOverWifiOnly = true,
    this.selectedLanguage = 'en',
  });

  AppSettingsEntity copyWith({
    bool? isDarkMode,
    bool? pushNotificationsEnabled,
    bool? emailNotificationsEnabled,
    bool? downloadOverWifiOnly,
    String? selectedLanguage,
  }) {
    return AppSettingsEntity(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      pushNotificationsEnabled: pushNotificationsEnabled ?? this.pushNotificationsEnabled,
      emailNotificationsEnabled: emailNotificationsEnabled ?? this.emailNotificationsEnabled,
      downloadOverWifiOnly: downloadOverWifiOnly ?? this.downloadOverWifiOnly,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
    );
  }

  @override
  List<Object?> get props => [
        isDarkMode,
        pushNotificationsEnabled,
        emailNotificationsEnabled,
        downloadOverWifiOnly,
        selectedLanguage,
      ];
}
