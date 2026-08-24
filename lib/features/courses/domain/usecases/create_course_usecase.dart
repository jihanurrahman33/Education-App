import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/course_entity.dart';
import '../repositories/course_repository.dart';

class CreateCourseParams extends Equatable {
  final String title;
  final String description;
  final bool isPublished;
  final String? category;
  final double? price;

  const CreateCourseParams({
    required this.title,
    required this.description,
    this.isPublished = false,
    this.category,
    this.price,
  });

  @override
  List<Object?> get props => [title, description, isPublished, category, price];
}

class CreateCourseUseCase implements UseCase<CourseEntity, CreateCourseParams> {
  final CourseRepository repository;

  const CreateCourseUseCase(this.repository);

  @override
  ResultFuture<CourseEntity> call(CreateCourseParams params) {
    return repository.createCourse(
      title: params.title,
      description: params.description,
      isPublished: params.isPublished,
      category: params.category,
      price: params.price,
    );
  }
}
