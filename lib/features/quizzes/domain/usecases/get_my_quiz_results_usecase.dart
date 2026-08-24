import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/quiz_entity.dart';
import '../repositories/quiz_repository.dart';

class GetMyQuizResultsParams extends Equatable {
  final int? page;

  const GetMyQuizResultsParams({this.page});

  @override
  List<Object?> get props => [page];
}

class GetMyQuizResultsUseCase implements UseCase<List<QuizResultEntity>, GetMyQuizResultsParams> {
  final QuizRepository repository;

  const GetMyQuizResultsUseCase(this.repository);

  @override
  ResultFuture<List<QuizResultEntity>> call(GetMyQuizResultsParams params) {
    return repository.getMyQuizResults(page: params.page);
  }
}
