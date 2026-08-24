import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/quiz_entity.dart';
import '../repositories/quiz_repository.dart';

class CreateQuizParams extends Equatable {
  final int lessonId;
  final String title;
  final String? description;
  final int? passScorePercent;

  const CreateQuizParams({
    required this.lessonId,
    required this.title,
    this.description,
    this.passScorePercent,
  });

  @override
  List<Object?> get props => [lessonId, title, description, passScorePercent];
}

class CreateQuizUseCase implements UseCase<QuizEntity, CreateQuizParams> {
  final QuizRepository repository;

  const CreateQuizUseCase(this.repository);

  @override
  ResultFuture<QuizEntity> call(CreateQuizParams params) {
    return repository.createQuiz(
      lessonId: params.lessonId,
      title: params.title,
      description: params.description,
      passScorePercent: params.passScorePercent,
    );
  }
}
