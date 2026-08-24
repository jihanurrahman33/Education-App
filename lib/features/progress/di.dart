import 'package:get_it/get_it.dart';
import '../../core/networking/api_client.dart';
import 'data/datasources/progress_remote_data_source.dart';
import 'data/repositories/progress_repository_impl.dart';
import 'domain/repositories/progress_repository.dart';
import 'domain/usecases/enroll_in_course_usecase.dart';
import 'domain/usecases/generate_certificate_usecase.dart';
import 'domain/usecases/get_certificates_usecase.dart';
import 'domain/usecases/get_completed_lessons_usecase.dart';
import 'domain/usecases/get_course_progress_usecase.dart';
import 'domain/usecases/get_enrollments_usecase.dart';
import 'domain/usecases/get_my_progress_usecase.dart';
import 'domain/usecases/get_progress_summary_usecase.dart';
import 'domain/usecases/get_teacher_course_students_progress_usecase.dart';
import 'domain/usecases/mark_lesson_completed_usecase.dart';

void initProgressFeature(GetIt sl) {
  // Data Sources
  sl.registerLazySingleton<ProgressRemoteDataSource>(
    () => ProgressRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );

  // Repositories
  sl.registerLazySingleton<ProgressRepository>(
    () => ProgressRepositoryImpl(remoteDataSource: sl<ProgressRemoteDataSource>()),
  );

  // Use Cases
  sl.registerLazySingleton<GetProgressSummaryUseCase>(
    () => GetProgressSummaryUseCase(sl<ProgressRepository>()),
  );
  sl.registerLazySingleton<GetMyProgressUseCase>(
    () => GetMyProgressUseCase(sl<ProgressRepository>()),
  );
  sl.registerLazySingleton<GetCourseProgressUseCase>(
    () => GetCourseProgressUseCase(sl<ProgressRepository>()),
  );
  sl.registerLazySingleton<EnrollInCourseUseCase>(
    () => EnrollInCourseUseCase(sl<ProgressRepository>()),
  );
  sl.registerLazySingleton<GetEnrollmentsUseCase>(
    () => GetEnrollmentsUseCase(sl<ProgressRepository>()),
  );
  sl.registerLazySingleton<MarkLessonCompletedUseCase>(
    () => MarkLessonCompletedUseCase(sl<ProgressRepository>()),
  );
  sl.registerLazySingleton<GetCompletedLessonsUseCase>(
    () => GetCompletedLessonsUseCase(sl<ProgressRepository>()),
  );
  sl.registerLazySingleton<GenerateCertificateUseCase>(
    () => GenerateCertificateUseCase(sl<ProgressRepository>()),
  );
  sl.registerLazySingleton<GetCertificatesUseCase>(
    () => GetCertificatesUseCase(sl<ProgressRepository>()),
  );
  sl.registerLazySingleton<GetTeacherCourseStudentsProgressUseCase>(
    () => GetTeacherCourseStudentsProgressUseCase(sl<ProgressRepository>()),
  );
}
