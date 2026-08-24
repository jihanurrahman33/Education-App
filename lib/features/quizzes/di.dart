import 'package:get_it/get_it.dart';
import '../../core/networking/api_client.dart';
import 'data/datasources/quiz_remote_data_source.dart';
import 'data/repositories/quiz_repository_impl.dart';
import 'domain/repositories/quiz_repository.dart';
import 'domain/usecases/create_question_usecase.dart';
import 'domain/usecases/create_quiz_usecase.dart';
import 'domain/usecases/delete_question_usecase.dart';
import 'domain/usecases/delete_quiz_usecase.dart';
import 'domain/usecases/get_my_quiz_results_usecase.dart';
import 'domain/usecases/get_questions_usecase.dart';
import 'domain/usecases/get_quiz_details_usecase.dart';
import 'domain/usecases/get_quiz_teacher_results_usecase.dart';
import 'domain/usecases/get_quizzes_usecase.dart';
import 'domain/usecases/submit_quiz_usecase.dart';
import 'domain/usecases/take_quiz_usecase.dart';
import 'domain/usecases/update_question_usecase.dart';
import 'domain/usecases/update_quiz_usecase.dart';
import 'presentation/bloc/quiz_bloc.dart';

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
  sl.registerLazySingleton<GetQuizzesUseCase>(
    () => GetQuizzesUseCase(sl<QuizRepository>()),
  );
  sl.registerLazySingleton<CreateQuizUseCase>(
    () => CreateQuizUseCase(sl<QuizRepository>()),
  );
  sl.registerLazySingleton<GetQuizDetailsUseCase>(
    () => GetQuizDetailsUseCase(sl<QuizRepository>()),
  );
  sl.registerLazySingleton<UpdateQuizUseCase>(
    () => UpdateQuizUseCase(sl<QuizRepository>()),
  );
  sl.registerLazySingleton<DeleteQuizUseCase>(
    () => DeleteQuizUseCase(sl<QuizRepository>()),
  );
  sl.registerLazySingleton<TakeQuizUseCase>(
    () => TakeQuizUseCase(sl<QuizRepository>()),
  );
  sl.registerLazySingleton<SubmitQuizUseCase>(
    () => SubmitQuizUseCase(sl<QuizRepository>()),
  );
  sl.registerLazySingleton<GetMyQuizResultsUseCase>(
    () => GetMyQuizResultsUseCase(sl<QuizRepository>()),
  );
  sl.registerLazySingleton<GetQuizTeacherResultsUseCase>(
    () => GetQuizTeacherResultsUseCase(sl<QuizRepository>()),
  );
  sl.registerLazySingleton<GetQuestionsUseCase>(
    () => GetQuestionsUseCase(sl<QuizRepository>()),
  );
  sl.registerLazySingleton<CreateQuestionUseCase>(
    () => CreateQuestionUseCase(sl<QuizRepository>()),
  );
  sl.registerLazySingleton<UpdateQuestionUseCase>(
    () => UpdateQuestionUseCase(sl<QuizRepository>()),
  );
  sl.registerLazySingleton<DeleteQuestionUseCase>(
    () => DeleteQuestionUseCase(sl<QuizRepository>()),
  );

  // Presentation (Bloc)
  sl.registerFactory<QuizBloc>(
    () => QuizBloc(
      getQuizzesUseCase: sl<GetQuizzesUseCase>(),
      createQuizUseCase: sl<CreateQuizUseCase>(),
      getQuizDetailsUseCase: sl<GetQuizDetailsUseCase>(),
      updateQuizUseCase: sl<UpdateQuizUseCase>(),
      deleteQuizUseCase: sl<DeleteQuizUseCase>(),
      takeQuizUseCase: sl<TakeQuizUseCase>(),
      submitQuizUseCase: sl<SubmitQuizUseCase>(),
      getMyQuizResultsUseCase: sl<GetMyQuizResultsUseCase>(),
      getQuizTeacherResultsUseCase: sl<GetQuizTeacherResultsUseCase>(),
      createQuestionUseCase: sl<CreateQuestionUseCase>(),
    ),
  );
}
