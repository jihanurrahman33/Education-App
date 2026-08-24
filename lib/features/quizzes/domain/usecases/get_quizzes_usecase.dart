import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/quiz_entity.dart';
import '../repositories/quiz_repository.dart';

class GetQuizzesParams extends Equatable {
  final int? page;

  const GetQuizzesParams({this.page});

  @override
  List<Object?> get props => [page];
}

class GetQuizzesUseCase implements UseCase<List<QuizEntity>, GetQuizzesParams> {
  final QuizRepository repository;

  const GetQuizzesUseCase(this.repository);

  @override
  ResultFuture<List<QuizEntity>> call(GetQuizzesParams params) {
    return repository.getQuizzes(page: params.page);
  }
}
