import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/admin/di.dart';
import '../../features/auth/di.dart';
import '../../features/certificates/di.dart';
import '../../features/courses/di.dart';
import '../../features/dashboard/di.dart';
import '../../features/notifications/di.dart';
import '../../features/onboarding/di.dart';
import '../../features/progress/di.dart';
import '../../features/quizzes/di.dart';
import '../../features/settings/di.dart';
import '../networking/api_client.dart';

final sl = GetIt.instance;

Future<void> initGlobalDependencies() async {
  // 1. External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  final dio = Dio();
  sl.registerLazySingleton<Dio>(() => dio);

  // 2. Core infrastructure
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(
      dio: sl<Dio>(),
      prefs: sl<SharedPreferences>(),
    ),
  );

  // 3. Feature modules
  initOnboardingDependencies();
  initAuthFeature(sl);
  initCourseFeature(sl);
  initQuizFeature(sl);
  initProgressFeature(sl);
  initCertificateFeature(sl);
  initAdminFeature(sl);
  initNotificationFeature(sl);
  initSettingsFeature(sl);
  initDashboardFeature(sl);
}
