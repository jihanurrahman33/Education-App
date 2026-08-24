import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/course_entity.dart';
import '../repositories/course_repository.dart';

class UpdateChapterParams extends Equatable {
  final int id;
  final int courseId;
  final String title;
  final int order;

  const UpdateChapterParams({
    required this.id,
    required this.courseId,
    required this.title,
    this.order = 0,
  });

  @override
  List<Object?> get props => [id, courseId, title, order];
}

class UpdateChapterUseCase implements UseCase<ChapterEntity, UpdateChapterParams> {
  final CourseRepository repository;

  const UpdateChapterUseCase(this.repository);

  @override
  ResultFuture<ChapterEntity> call(UpdateChapterParams params) {
    return repository.updateChapter(
      id: params.id,
      courseId: params.courseId,
      title: params.title,
      order: params.order,
    );
  }
}
