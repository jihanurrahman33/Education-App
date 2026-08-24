import '../../../../core/utils/typedefs.dart';
import '../entities/app_settings_entity.dart';

abstract class SettingsRepository {
  ResultFuture<AppSettingsEntity> getSettings();
  ResultVoid saveSettings(AppSettingsEntity settings);
}
