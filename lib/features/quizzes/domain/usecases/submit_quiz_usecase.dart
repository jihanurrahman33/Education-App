import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/quiz_entity.dart';
import '../repositories/quiz_repository.dart';

class SubmitQuizParams extends Equatable {
  final int quizId;
  final Map<int, int> selectedAnswers;

  const SubmitQuizParams({
    required this.quizId,
    required this.selectedAnswers,
  });

  @override
  List<Object?> get props => [quizId, selectedAnswers];
}

class SubmitQuizUseCase implements UseCase<QuizSubmissionResultEntity, SubmitQuizParams> {
  final QuizRepository _repository;

  const SubmitQuizUseCase(this._repository);

  @override
  ResultFuture<QuizSubmissionResultEntity> call(SubmitQuizParams params) {
    return _repository.submitQuiz(
      quizId: params.quizId,
      selectedAnswers: params.selectedAnswers,
    );
  }
}
