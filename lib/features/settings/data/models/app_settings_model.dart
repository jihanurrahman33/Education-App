import '../../domain/entities/app_settings_entity.dart';

class AppSettingsModel extends AppSettingsEntity {
  const AppSettingsModel({
    super.isDarkMode = false,
    super.pushNotificationsEnabled = true,
    super.emailNotificationsEnabled = true,
    super.downloadOverWifiOnly = true,
    super.selectedLanguage = 'en',
  });

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) {
    return AppSettingsModel(
      isDarkMode: json['isDarkMode'] as bool? ?? false,
      pushNotificationsEnabled: json['pushNotificationsEnabled'] as bool? ?? true,
      emailNotificationsEnabled: json['emailNotificationsEnabled'] as bool? ?? true,
      downloadOverWifiOnly: json['downloadOverWifiOnly'] as bool? ?? true,
      selectedLanguage: json['selectedLanguage'] as String? ?? 'en',
    );
  }

  factory AppSettingsModel.fromEntity(AppSettingsEntity entity) {
    return AppSettingsModel(
      isDarkMode: entity.isDarkMode,
      pushNotificationsEnabled: entity.pushNotificationsEnabled,
      emailNotificationsEnabled: entity.emailNotificationsEnabled,
      downloadOverWifiOnly: entity.downloadOverWifiOnly,
      selectedLanguage: entity.selectedLanguage,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isDarkMode': isDarkMode,
      'pushNotificationsEnabled': pushNotificationsEnabled,
      'emailNotificationsEnabled': emailNotificationsEnabled,
      'downloadOverWifiOnly': downloadOverWifiOnly,
      'selectedLanguage': selectedLanguage,
    };
  }
}
