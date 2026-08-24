import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/course_entity.dart';
import '../repositories/course_repository.dart';

class PatchChapterParams extends Equatable {
  final int id;
  final int? courseId;
  final String? title;
  final int? order;

  const PatchChapterParams({
    required this.id,
    this.courseId,
    this.title,
    this.order,
  });

  @override
  List<Object?> get props => [id, courseId, title, order];
}

class PatchChapterUseCase implements UseCase<ChapterEntity, PatchChapterParams> {
  final CourseRepository repository;

  const PatchChapterUseCase(this.repository);

  @override
  ResultFuture<ChapterEntity> call(PatchChapterParams params) {
    return repository.patchChapter(
      id: params.id,
      courseId: params.courseId,
      title: params.title,
      order: params.order,
    );
  }
}
