import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/app_settings_entity.dart';
import '../repositories/settings_repository.dart';

class GetSettingsUseCase implements UseCase<AppSettingsEntity, NoParams> {
  final SettingsRepository repository;

  const GetSettingsUseCase(this.repository);

  @override
  ResultFuture<AppSettingsEntity> call([NoParams params = const NoParams()]) {
    return repository.getSettings();
  }
}
