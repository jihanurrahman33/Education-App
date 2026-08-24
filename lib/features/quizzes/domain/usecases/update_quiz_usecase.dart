import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/quiz_entity.dart';
import '../repositories/quiz_repository.dart';

class UpdateQuizParams extends Equatable {
  final int quizId;
  final int lessonId;
  final String title;
  final String? description;
  final int? passScorePercent;
  final bool isPartial;

  const UpdateQuizParams({
    required this.quizId,
    required this.lessonId,
    required this.title,
    this.description,
    this.passScorePercent,
    this.isPartial = false,
  });

  @override
  List<Object?> get props => [
        quizId,
        lessonId,
        title,
        description,
        passScorePercent,
        isPartial,
      ];
}

class UpdateQuizUseCase implements UseCase<QuizEntity, UpdateQuizParams> {
  final QuizRepository repository;

  const UpdateQuizUseCase(this.repository);

  @override
  ResultFuture<QuizEntity> call(UpdateQuizParams params) {
    if (params.isPartial) {
      return repository.partialUpdateQuiz(
        quizId: params.quizId,
        lessonId: params.lessonId,
        title: params.title,
        description: params.description,
        passScorePercent: params.passScorePercent,
      );
    }
    return repository.updateQuiz(
      quizId: params.quizId,
      lessonId: params.lessonId,
      title: params.title,
      description: params.description,
      passScorePercent: params.passScorePercent,
    );
  }
}
