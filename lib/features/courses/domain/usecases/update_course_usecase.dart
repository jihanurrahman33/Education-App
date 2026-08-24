import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/course_entity.dart';
import '../repositories/course_repository.dart';

class UpdateCourseParams extends Equatable {
  final int id;
  final String title;
  final String? description;
  final bool? isPublished;

  const UpdateCourseParams({
    required this.id,
    required this.title,
    this.description,
    this.isPublished,
  });

  @override
  List<Object?> get props => [id, title, description, isPublished];
}

class UpdateCourseUseCase implements UseCase<CourseEntity, UpdateCourseParams> {
  final CourseRepository repository;

  const UpdateCourseUseCase(this.repository);

  @override
  ResultFuture<CourseEntity> call(UpdateCourseParams params) {
    return repository.updateCourse(
      id: params.id,
      title: params.title,
      description: params.description,
      isPublished: params.isPublished,
    );
  }
}
