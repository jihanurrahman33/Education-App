import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/app_settings_entity.dart';
import '../repositories/settings_repository.dart';

class SaveSettingsUseCase implements UseCase<void, AppSettingsEntity> {
  final SettingsRepository repository;

  const SaveSettingsUseCase(this.repository);

  @override
  ResultVoid call(AppSettingsEntity settings) {
    return repository.saveSettings(settings);
  }
}
