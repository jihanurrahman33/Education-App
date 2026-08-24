import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../repositories/course_repository.dart';

class DeleteChapterUseCase implements UseCase<void, int> {
  final CourseRepository repository;

  const DeleteChapterUseCase(this.repository);

  @override
  ResultVoid call(int chapterId) {
    return repository.deleteChapter(chapterId);
  }
}
