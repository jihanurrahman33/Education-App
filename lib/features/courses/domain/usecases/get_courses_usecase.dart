import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/course_entity.dart';
import '../repositories/course_repository.dart';

class GetCoursesParams extends Equatable {
  final String? category;
  final String? searchQuery;
  final int? page;

  const GetCoursesParams({
    this.category,
    this.searchQuery,
    this.page,
  });

  @override
  List<Object?> get props => [category, searchQuery, page];
}

class GetCoursesUseCase implements UseCase<List<CourseEntity>, GetCoursesParams> {
  final CourseRepository _repository;

  const GetCoursesUseCase(this._repository);

  @override
  ResultFuture<List<CourseEntity>> call([GetCoursesParams params = const GetCoursesParams()]) {
    return _repository.getCourses(
      category: params.category,
      searchQuery: params.searchQuery,
      page: params.page,
    );
  }
}
