import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/quiz_entity.dart';
import '../repositories/quiz_repository.dart';

class GetQuestionsParams extends Equatable {
  final int? page;

  const GetQuestionsParams({this.page});

  @override
  List<Object?> get props => [page];
}

class GetQuestionsUseCase implements UseCase<List<QuestionEntity>, GetQuestionsParams> {
  final QuizRepository repository;

  const GetQuestionsUseCase(this.repository);

  @override
  ResultFuture<List<QuestionEntity>> call(GetQuestionsParams params) {
    return repository.getQuestions(page: params.page);
  }
}
