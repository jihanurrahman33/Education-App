import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/course_entity.dart';
import '../repositories/course_repository.dart';

class GetCoursesParams extends Equatable {
  final String? category;
  final String? searchQuery;

  const GetCoursesParams({
    this.category,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [category, searchQuery];
}

class GetCoursesUseCase implements UseCase<List<CourseEntity>, GetCoursesParams> {
  final CourseRepository _repository;

  const GetCoursesUseCase(this._repository);

  @override
  ResultFuture<List<CourseEntity>> call(GetCoursesParams params) {
    return _repository.getCourses(
      category: params.category,
      searchQuery: params.searchQuery,
    );
  }
}
