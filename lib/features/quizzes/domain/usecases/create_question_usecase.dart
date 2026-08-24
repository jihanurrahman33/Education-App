import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/quiz_entity.dart';
import '../repositories/quiz_repository.dart';

class CreateQuestionParams extends Equatable {
  final int quizId;
  final String text;
  final int? order;
  final List<ChoiceEntity> choices;

  const CreateQuestionParams({
    required this.quizId,
    required this.text,
    this.order,
    required this.choices,
  });

  @override
  List<Object?> get props => [quizId, text, order, choices];
}

class CreateQuestionUseCase implements UseCase<QuestionEntity, CreateQuestionParams> {
  final QuizRepository repository;

  const CreateQuestionUseCase(this.repository);

  @override
  ResultFuture<QuestionEntity> call(CreateQuestionParams params) {
    return repository.createQuestion(
      quizId: params.quizId,
      text: params.text,
      order: params.order,
      choices: params.choices,
    );
  }
}
