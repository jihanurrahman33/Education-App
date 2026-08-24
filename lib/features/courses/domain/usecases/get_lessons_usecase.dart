import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/course_entity.dart';
import '../repositories/course_repository.dart';

class GetLessonsParams extends Equatable {
  final int? chapterId;
  final int? page;

  const GetLessonsParams({this.chapterId, this.page});

  @override
  List<Object?> get props => [chapterId, page];
}

class GetLessonsUseCase implements UseCase<List<LessonEntity>, GetLessonsParams> {
  final CourseRepository repository;

  const GetLessonsUseCase(this.repository);

  @override
  ResultFuture<List<LessonEntity>> call([GetLessonsParams params = const GetLessonsParams()]) {
    return repository.getLessons(chapterId: params.chapterId, page: params.page);
  }
}
