import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/quiz_entity.dart';
import '../../domain/repositories/quiz_repository.dart';
import '../datasources/quiz_remote_data_source.dart';

class QuizRepositoryImpl implements QuizRepository {
  final QuizRemoteDataSource _remoteDataSource;

  const QuizRepositoryImpl({required this._remoteDataSource});

  @override
  ResultFuture<List<QuizEntity>> getQuizzes({int? page}) async {
    try {
      final quizzes = await _remoteDataSource.getQuizzes(page: page);
      return Right(quizzes);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<QuizEntity> createQuiz({
    required int lessonId,
    required String title,
    String? description,
    int? passScorePercent,
  }) async {
    try {
      final quiz = await _remoteDataSource.createQuiz(
        lessonId: lessonId,
        title: title,
        description: description,
        passScorePercent: passScorePercent,
      );
      return Right(quiz);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<QuizEntity> getQuizDetails(int quizId) async {
    try {
      final quiz = await _remoteDataSource.getQuizDetails(quizId);
      return Right(quiz);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<QuizEntity> updateQuiz({
    required int quizId,
    required int lessonId,
    required String title,
    String? description,
    int? passScorePercent,
  }) async {
    try {
      final quiz = await _remoteDataSource.updateQuiz(
        quizId: quizId,
        lessonId: lessonId,
        title: title,
        description: description,
        passScorePercent: passScorePercent,
      );
      return Right(quiz);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<QuizEntity> partialUpdateQuiz({
    required int quizId,
    int? lessonId,
    String? title,
    String? description,
    int? passScorePercent,
  }) async {
    try {
      final quiz = await _remoteDataSource.partialUpdateQuiz(
        quizId: quizId,
        lessonId: lessonId,
        title: title,
        description: description,
        passScorePercent: passScorePercent,
      );
      return Right(quiz);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  ResultVoid deleteQuiz(int quizId) async {
    try {
      await _remoteDataSource.deleteQuiz(quizId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<QuizEntity> takeQuiz(int quizId) async {
    try {
      final quiz = await _remoteDataSource.takeQuiz(quizId);
      return Right(quiz);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<QuizResultEntity> submitQuiz({
    required int quizId,
    required List<AnswerSubmitEntity> answers,
  }) async {
    try {
      final result = await _remoteDataSource.submitQuiz(
        quizId: quizId,
        answers: answers,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<List<QuizResultEntity>> getMyQuizResults({int? page}) async {
    try {
      final results = await _remoteDataSource.getMyQuizResults(page: page);
      return Right(results);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<List<QuizResultEntity>> getQuizTeacherResults(int quizId) async {
    try {
      final results = await _remoteDataSource.getQuizTeacherResults(quizId);
      return Right(results);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<List<QuestionEntity>> getQuestions({int? page}) async {
    try {
      final questions = await _remoteDataSource.getQuestions(page: page);
      return Right(questions);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<QuestionEntity> createQuestion({
    required int quizId,
    required String text,
    int? order,
    required List<ChoiceEntity> choices,
  }) async {
    try {
      final question = await _remoteDataSource.createQuestion(
        quizId: quizId,
        text: text,
        order: order,
        choices: choices,
      );
      return Right(question);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<QuestionEntity> getQuestionDetails(int questionId) async {
    try {
      final question = await _remoteDataSource.getQuestionDetails(questionId);
      return Right(question);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<QuestionEntity> updateQuestion({
    required int questionId,
    required int quizId,
    required String text,
    int? order,
    required List<ChoiceEntity> choices,
  }) async {
    try {
      final question = await _remoteDataSource.updateQuestion(
        questionId: questionId,
        quizId: quizId,
        text: text,
        order: order,
        choices: choices,
      );
      return Right(question);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<QuestionEntity> partialUpdateQuestion({
    required int questionId,
    int? quizId,
    String? text,
    int? order,
    List<ChoiceEntity>? choices,
  }) async {
    try {
      final question = await _remoteDataSource.partialUpdateQuestion(
        questionId: questionId,
        quizId: quizId,
        text: text,
        order: order,
        choices: choices,
      );
      return Right(question);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  ResultVoid deleteQuestion(int questionId) async {
    try {
      await _remoteDataSource.deleteQuestion(questionId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
