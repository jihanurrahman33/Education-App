import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/progress_entity.dart';
import '../repositories/progress_repository.dart';

class GetProgressSummaryUseCase implements UseCase<ProgressSummaryEntity, NoParams> {
  final ProgressRepository _repository;

  const GetProgressSummaryUseCase(this._repository);

  @override
  ResultFuture<ProgressSummaryEntity> call(NoParams params) {
    return _repository.getProgressSummary();
  }
}
