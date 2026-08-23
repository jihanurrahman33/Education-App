import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/course_entity.dart';
import '../repositories/course_repository.dart';

class GetCourseDetailsParams extends Equatable {
  final int courseId;

  const GetCourseDetailsParams({required this.courseId});

  @override
  List<Object?> get props => [courseId];
}

class GetCourseDetailsUseCase implements UseCase<CourseEntity, GetCourseDetailsParams> {
  final CourseRepository _repository;

  const GetCourseDetailsUseCase(this._repository);

  @override
  ResultFuture<CourseEntity> call(GetCourseDetailsParams params) {
    return _repository.getCourseDetails(params.courseId);
  }
}
