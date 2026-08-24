import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../repositories/quiz_repository.dart';

class DeleteQuestionParams extends Equatable {
  final int questionId;

  const DeleteQuestionParams({required this.questionId});

  @override
  List<Object?> get props => [questionId];
}

class DeleteQuestionUseCase implements UseCase<void, DeleteQuestionParams> {
  final QuizRepository repository;

  const DeleteQuestionUseCase(this.repository);

  @override
  ResultVoid call(DeleteQuestionParams params) {
    return repository.deleteQuestion(params.questionId);
  }
}
