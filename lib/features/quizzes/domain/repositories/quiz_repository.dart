import '../../../../core/utils/typedefs.dart';
import '../entities/quiz_entity.dart';

abstract class QuizRepository {
  // Quiz Operations
  ResultFuture<List<QuizEntity>> getQuizzes({int? page});

  ResultFuture<QuizEntity> createQuiz({
    required int lessonId,
    required String title,
    String? description,
    int? passScorePercent,
  });

  ResultFuture<QuizEntity> getQuizDetails(int quizId);

  ResultFuture<QuizEntity> updateQuiz({
    required int quizId,
    required int lessonId,
    required String title,
    String? description,
    int? passScorePercent,
  });

  ResultFuture<QuizEntity> partialUpdateQuiz({
    required int quizId,
    int? lessonId,
    String? title,
    String? description,
    int? passScorePercent,
  });

  ResultVoid deleteQuiz(int quizId);

  // Student Actions
  ResultFuture<QuizEntity> takeQuiz(int quizId);

  ResultFuture<QuizResultEntity> submitQuiz({
    required int quizId,
    required List<AnswerSubmitEntity> answers,
  });

  ResultFuture<List<QuizResultEntity>> getMyQuizResults({int? page});

  ResultFuture<List<QuizResultEntity>> getQuizTeacherResults(int quizId);

  // Question Operations
  ResultFuture<List<QuestionEntity>> getQuestions({int? page});

  ResultFuture<QuestionEntity> createQuestion({
    required int quizId,
    required String text,
    int? order,
    required List<ChoiceEntity> choices,
  });

  ResultFuture<QuestionEntity> getQuestionDetails(int questionId);

  ResultFuture<QuestionEntity> updateQuestion({
    required int questionId,
    required int quizId,
    required String text,
    int? order,
    required List<ChoiceEntity> choices,
  });

  ResultFuture<QuestionEntity> partialUpdateQuestion({
    required int questionId,
    int? quizId,
    String? text,
    int? order,
    List<ChoiceEntity>? choices,
  });

  ResultVoid deleteQuestion(int questionId);
}
