import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/course_entity.dart';
import '../repositories/course_repository.dart';

class PatchCourseParams extends Equatable {
  final int id;
  final String? title;
  final String? description;
  final bool? isPublished;

  const PatchCourseParams({
    required this.id,
    this.title,
    this.description,
    this.isPublished,
  });

  @override
  List<Object?> get props => [id, title, description, isPublished];
}

class PatchCourseUseCase implements UseCase<CourseEntity, PatchCourseParams> {
  final CourseRepository repository;

  const PatchCourseUseCase(this.repository);

  @override
  ResultFuture<CourseEntity> call(PatchCourseParams params) {
    return repository.patchCourse(
      id: params.id,
      title: params.title,
      description: params.description,
      isPublished: params.isPublished,
    );
  }
}
