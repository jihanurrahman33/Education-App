import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/progress_entity.dart';
import '../repositories/progress_repository.dart';

class GetMyProgressUseCase implements UseCase<List<CourseProgressEntity>, NoParams> {
  final ProgressRepository repository;

  const GetMyProgressUseCase(this.repository);

  @override
  ResultFuture<List<CourseProgressEntity>> call([NoParams params = const NoParams()]) {
    return repository.getMyProgress();
  }
}
