import 'package:get_it/get_it.dart';
import '../../core/networking/api_client.dart';
import 'data/datasources/quiz_remote_data_source.dart';
import 'data/repositories/quiz_repository_impl.dart';
import 'domain/repositories/quiz_repository.dart';
import 'domain/usecases/get_quiz_details_usecase.dart';
import 'domain/usecases/submit_quiz_usecase.dart';

void initQuizFeature(GetIt sl) {
  // Data Sources
  sl.registerLazySingleton<QuizRemoteDataSource>(
    () => QuizRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );

  // Repositories
  sl.registerLazySingleton<QuizRepository>(
    () => QuizRepositoryImpl(remoteDataSource: sl<QuizRemoteDataSource>()),
  );

  // Use Cases
  sl.registerLazySingleton<GetQuizDetailsUseCase>(
    () => GetQuizDetailsUseCase(sl<QuizRepository>()),
  );
  sl.registerLazySingleton<SubmitQuizUseCase>(
    () => SubmitQuizUseCase(sl<QuizRepository>()),
  );
}
