import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/quiz_entity.dart';
import '../repositories/quiz_repository.dart';

class TakeQuizParams extends Equatable {
  final int quizId;

  const TakeQuizParams({required this.quizId});

  @override
  List<Object?> get props => [quizId];
}

class TakeQuizUseCase implements UseCase<QuizEntity, TakeQuizParams> {
  final QuizRepository repository;

  const TakeQuizUseCase(this.repository);

  @override
  ResultFuture<QuizEntity> call(TakeQuizParams params) {
    return repository.takeQuiz(params.quizId);
  }
}
