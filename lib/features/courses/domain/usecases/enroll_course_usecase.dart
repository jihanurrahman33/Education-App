import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../repositories/course_repository.dart';

class EnrollCourseParams extends Equatable {
  final int courseId;

  const EnrollCourseParams({required this.courseId});

  @override
  List<Object?> get props => [courseId];
}

class EnrollCourseUseCase implements UseCase<void, EnrollCourseParams> {
  final CourseRepository _repository;

  const EnrollCourseUseCase(this._repository);

  @override
  ResultVoid call(EnrollCourseParams params) {
    return _repository.enrollInCourse(params.courseId);
  }
}
