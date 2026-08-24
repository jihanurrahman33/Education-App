import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/quiz_entity.dart';
import '../repositories/quiz_repository.dart';

class UpdateQuestionParams extends Equatable {
  final int questionId;
  final int quizId;
  final String text;
  final int? order;
  final List<ChoiceEntity> choices;
  final bool isPartial;

  const UpdateQuestionParams({
    required this.questionId,
    required this.quizId,
    required this.text,
    this.order,
    this.choices = const [],
    this.isPartial = false,
  });

  @override
  List<Object?> get props => [
        questionId,
        quizId,
        text,
        order,
        choices,
        isPartial,
      ];
}

class UpdateQuestionUseCase implements UseCase<QuestionEntity, UpdateQuestionParams> {
  final QuizRepository repository;

  const UpdateQuestionUseCase(this.repository);

  @override
  ResultFuture<QuestionEntity> call(UpdateQuestionParams params) {
    if (params.isPartial) {
      return repository.partialUpdateQuestion(
        questionId: params.questionId,
        quizId: params.quizId,
        text: params.text,
        order: params.order,
        choices: params.choices.isEmpty ? null : params.choices,
      );
    }
    return repository.updateQuestion(
      questionId: params.questionId,
      quizId: params.quizId,
      text: params.text,
      order: params.order,
      choices: params.choices,
    );
  }
}
