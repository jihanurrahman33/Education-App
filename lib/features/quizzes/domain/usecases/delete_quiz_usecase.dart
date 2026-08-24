import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../repositories/quiz_repository.dart';

class DeleteQuizParams extends Equatable {
  final int quizId;

  const DeleteQuizParams({required this.quizId});

  @override
  List<Object?> get props => [quizId];
}

class DeleteQuizUseCase implements UseCase<void, DeleteQuizParams> {
  final QuizRepository repository;

  const DeleteQuizUseCase(this.repository);

  @override
  ResultVoid call(DeleteQuizParams params) {
    return repository.deleteQuiz(params.quizId);
  }
}
