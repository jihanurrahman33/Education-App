import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/quiz_entity.dart';
import '../repositories/quiz_repository.dart';

class SubmitQuizParams extends Equatable {
  final int quizId;
  final List<AnswerSubmitEntity> answers;

  const SubmitQuizParams({
    required this.quizId,
    required this.answers,
  });

  @override
  List<Object?> get props => [quizId, answers];
}

class SubmitQuizUseCase implements UseCase<QuizResultEntity, SubmitQuizParams> {
  final QuizRepository repository;

  const SubmitQuizUseCase(this.repository);

  @override
  ResultFuture<QuizResultEntity> call(SubmitQuizParams params) {
    return repository.submitQuiz(
      quizId: params.quizId,
      answers: params.answers,
    );
  }
}
