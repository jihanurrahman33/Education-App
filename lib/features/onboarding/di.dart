import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/datasources/onboarding_local_data_source.dart';
import 'data/repositories/onboarding_repository_impl.dart';
import 'domain/repositories/onboarding_repository.dart';
import 'domain/usecases/check_onboarding_status_use_case.dart';
import 'domain/usecases/complete_onboarding_use_case.dart';
import 'domain/usecases/get_onboarding_items_use_case.dart';
import 'presentation/cubit/onboarding_cubit.dart';

void initOnboardingDependencies() {
  final sl = GetIt.instance;

  // 1. Data Sources
  if (!sl.isRegistered<OnboardingLocalDataSource>()) {
    sl.registerLazySingleton<OnboardingLocalDataSource>(
      () => OnboardingLocalDataSourceImpl(sl<SharedPreferences>()),
    );
  }

  // 2. Repository
  if (!sl.isRegistered<OnboardingRepository>()) {
    sl.registerLazySingleton<OnboardingRepository>(
      () => OnboardingRepositoryImpl(sl<OnboardingLocalDataSource>()),
    );
  }

  // 3. Use Cases
  if (!sl.isRegistered<CheckOnboardingStatusUseCase>()) {
    sl.registerLazySingleton(() => CheckOnboardingStatusUseCase(sl<OnboardingRepository>()));
  }
  if (!sl.isRegistered<CompleteOnboardingUseCase>()) {
    sl.registerLazySingleton(() => CompleteOnboardingUseCase(sl<OnboardingRepository>()));
  }
  if (!sl.isRegistered<GetOnboardingItemsUseCase>()) {
    sl.registerLazySingleton(() => GetOnboardingItemsUseCase(sl<OnboardingRepository>()));
  }

  // 4. Cubit / State Management
  if (!sl.isRegistered<OnboardingCubit>()) {
    sl.registerFactory(
      () => OnboardingCubit(
        getOnboardingItemsUseCase: sl<GetOnboardingItemsUseCase>(),
        completeOnboardingUseCase: sl<CompleteOnboardingUseCase>(),
        checkOnboardingStatusUseCase: sl<CheckOnboardingStatusUseCase>(),
      ),
    );
  }
}
