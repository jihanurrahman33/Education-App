import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/quiz_entity.dart';
import '../repositories/quiz_repository.dart';

class GetQuizDetailsParams extends Equatable {
  final int quizId;

  const GetQuizDetailsParams({required this.quizId});

  @override
  List<Object?> get props => [quizId];
}

class GetQuizDetailsUseCase implements UseCase<QuizEntity, GetQuizDetailsParams> {
  final QuizRepository _repository;

  const GetQuizDetailsUseCase(this._repository);

  @override
  ResultFuture<QuizEntity> call(GetQuizDetailsParams params) {
    return _repository.getQuizDetails(params.quizId);
  }
}
