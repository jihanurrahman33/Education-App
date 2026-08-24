import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/datasources/settings_local_data_source.dart';
import 'data/repositories/settings_repository_impl.dart';
import 'domain/repositories/settings_repository.dart';
import 'domain/usecases/get_settings_use_case.dart';
import 'domain/usecases/save_settings_use_case.dart';
import 'presentation/bloc/settings_bloc.dart';

void initSettingsFeature(GetIt sl) {
  // Use cases
  sl.registerLazySingleton(() => GetSettingsUseCase(sl()));
  sl.registerLazySingleton(() => SaveSettingsUseCase(sl()));

  // Repository
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(localDataSource: sl()),
  );

  // Data source
  sl.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(sharedPreferences: sl<SharedPreferences>()),
  );

  // Presentation (Bloc)
  sl.registerFactory(
    () => SettingsBloc(
      getSettingsUseCase: sl(),
      saveSettingsUseCase: sl(),
    ),
  );
}
