import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/admin_course_entity.dart';
import '../repositories/admin_repository.dart';

class GetPendingCoursesParams extends Equatable {
  final int? page;

  const GetPendingCoursesParams({this.page});

  @override
  List<Object?> get props => [page];
}

class GetPendingCoursesUseCase implements UseCase<List<AdminCourseEntity>, GetPendingCoursesParams> {
  final AdminRepository _repository;

  const GetPendingCoursesUseCase(this._repository);

  @override
  ResultFuture<List<AdminCourseEntity>> call(GetPendingCoursesParams params) {
    return _repository.getPendingCourses(page: params.page);
  }
}
