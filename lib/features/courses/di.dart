import 'package:get_it/get_it.dart';
import '../../core/networking/api_client.dart';
import 'data/datasources/course_remote_data_source.dart';
import 'data/repositories/course_repository_impl.dart';
import 'domain/repositories/course_repository.dart';
import 'domain/usecases/enroll_course_usecase.dart';
import 'domain/usecases/get_course_details_usecase.dart';
import 'domain/usecases/get_courses_usecase.dart';
import 'presentation/bloc/course_bloc.dart';

void initCourseFeature(GetIt sl) {
  // Data Sources
  sl.registerLazySingleton<CourseRemoteDataSource>(
    () => CourseRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );

  // Repositories
  sl.registerLazySingleton<CourseRepository>(
    () => CourseRepositoryImpl(remoteDataSource: sl<CourseRemoteDataSource>()),
  );

  // Use Cases
  sl.registerLazySingleton<GetCoursesUseCase>(
    () => GetCoursesUseCase(sl<CourseRepository>()),
  );
  sl.registerLazySingleton<GetCourseDetailsUseCase>(
    () => GetCourseDetailsUseCase(sl<CourseRepository>()),
  );
  sl.registerLazySingleton<EnrollCourseUseCase>(
    () => EnrollCourseUseCase(sl<CourseRepository>()),
  );

  // Presentation (Bloc)
  sl.registerFactory<CourseBloc>(
    () => CourseBloc(
      getCoursesUseCase: sl<GetCoursesUseCase>(),
      getCourseDetailsUseCase: sl<GetCourseDetailsUseCase>(),
      enrollCourseUseCase: sl<EnrollCourseUseCase>(),
    ),
  );
}
