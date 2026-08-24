import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/progress_entity.dart';
import '../repositories/progress_repository.dart';

class GetCompletedLessonsUseCase implements UseCase<List<CompletedLessonEntity>, int?> {
  final ProgressRepository repository;

  const GetCompletedLessonsUseCase(this.repository);

  @override
  ResultFuture<List<CompletedLessonEntity>> call([int? page]) {
    return repository.getCompletedLessons(page: page);
  }
}
