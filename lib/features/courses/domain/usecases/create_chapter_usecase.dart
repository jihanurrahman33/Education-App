import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/course_entity.dart';
import '../repositories/course_repository.dart';

class CreateChapterParams extends Equatable {
  final int courseId;
  final String title;
  final int order;

  const CreateChapterParams({
    required this.courseId,
    required this.title,
    this.order = 0,
  });

  @override
  List<Object?> get props => [courseId, title, order];
}

class CreateChapterUseCase implements UseCase<ChapterEntity, CreateChapterParams> {
  final CourseRepository repository;

  const CreateChapterUseCase(this.repository);

  @override
  ResultFuture<ChapterEntity> call(CreateChapterParams params) {
    return repository.createChapter(
      courseId: params.courseId,
      title: params.title,
      order: params.order,
    );
  }
}
