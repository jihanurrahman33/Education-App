import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/quiz_entity.dart';
import '../repositories/quiz_repository.dart';

class GetQuizTeacherResultsParams extends Equatable {
  final int quizId;

  const GetQuizTeacherResultsParams({required this.quizId});

  @override
  List<Object?> get props => [quizId];
}

class GetQuizTeacherResultsUseCase
    implements UseCase<List<QuizResultEntity>, GetQuizTeacherResultsParams> {
  final QuizRepository repository;

  const GetQuizTeacherResultsUseCase(this.repository);

  @override
  ResultFuture<List<QuizResultEntity>> call(GetQuizTeacherResultsParams params) {
    return repository.getQuizTeacherResults(params.quizId);
  }
}
