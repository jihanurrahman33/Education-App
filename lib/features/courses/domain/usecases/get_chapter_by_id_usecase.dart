import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/course_entity.dart';
import '../repositories/course_repository.dart';

class GetChapterByIdUseCase implements UseCase<ChapterEntity, int> {
  final CourseRepository repository;

  const GetChapterByIdUseCase(this.repository);

  @override
  ResultFuture<ChapterEntity> call(int chapterId) {
    return repository.getChapterById(chapterId);
  }
}
