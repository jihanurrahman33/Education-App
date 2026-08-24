import 'package:get_it/get_it.dart';
import '../../core/networking/api_client.dart';
import 'data/datasources/admin_remote_data_source.dart';
import 'data/repositories/admin_repository_impl.dart';
import 'domain/repositories/admin_repository.dart';
import 'domain/usecases/approve_course_use_case.dart';
import 'domain/usecases/approve_teacher_use_case.dart';
import 'domain/usecases/create_user_use_case.dart';
import 'domain/usecases/delete_user_use_case.dart';
import 'domain/usecases/get_admin_stats_use_case.dart';
import 'domain/usecases/get_pending_courses_use_case.dart';
import 'domain/usecases/get_pending_teachers_use_case.dart';
import 'domain/usecases/get_top_courses_use_case.dart';
import 'domain/usecases/get_user_by_id_use_case.dart';
import 'domain/usecases/get_users_use_case.dart';
import 'domain/usecases/patch_user_use_case.dart';
import 'domain/usecases/reject_course_use_case.dart';
import 'domain/usecases/update_user_use_case.dart';
import 'presentation/bloc/admin_bloc.dart';

void initAdminFeature(GetIt sl) {
  // Use cases
  sl.registerLazySingleton(() => GetAdminStatsUseCase(sl()));
  sl.registerLazySingleton(() => GetTopCoursesUseCase(sl()));
  sl.registerLazySingleton(() => GetPendingCoursesUseCase(sl()));
  sl.registerLazySingleton(() => GetPendingTeachersUseCase(sl()));
  sl.registerLazySingleton(() => GetUsersUseCase(sl()));
  sl.registerLazySingleton(() => GetUserByIdUseCase(sl()));
  sl.registerLazySingleton(() => CreateUserUseCase(sl()));
  sl.registerLazySingleton(() => UpdateUserUseCase(sl()));
  sl.registerLazySingleton(() => PatchUserUseCase(sl()));
  sl.registerLazySingleton(() => DeleteUserUseCase(sl()));
  sl.registerLazySingleton(() => ApproveCourseUseCase(sl()));
  sl.registerLazySingleton(() => ApproveTeacherUseCase(sl()));
  sl.registerLazySingleton(() => RejectCourseUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AdminRepository>(
    () => AdminRepositoryImpl(remoteDataSource: sl()),
  );

  // Data source
  sl.registerLazySingleton<AdminRemoteDataSource>(
    () => AdminRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );

  // Presentation (Bloc)
  sl.registerFactory(
    () => AdminBloc(
      getAdminStatsUseCase: sl(),
      getTopCoursesUseCase: sl(),
      getPendingTeachersUseCase: sl(),
      approveTeacherUseCase: sl(),
      getPendingCoursesUseCase: sl(),
      approveCourseUseCase: sl(),
      rejectCourseUseCase: sl(),
      getUsersUseCase: sl(),
      createUserUseCase: sl(),
      updateUserUseCase: sl(),
      patchUserUseCase: sl(),
      deleteUserUseCase: sl(),
    ),
  );
}
