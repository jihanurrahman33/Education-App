import '../../../../core/utils/typedefs.dart';
import '../entities/quiz_entity.dart';

abstract class QuizRepository {
  ResultFuture<QuizEntity> getQuizDetails(int quizId);

  ResultFuture<QuizSubmissionResultEntity> submitQuiz({
    required int quizId,
    required Map<int, int> selectedAnswers, // questionId -> choiceId
  });
}
