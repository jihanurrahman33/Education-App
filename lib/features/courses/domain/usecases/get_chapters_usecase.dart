import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/course_entity.dart';
import '../repositories/course_repository.dart';

class GetChaptersParams extends Equatable {
  final int? page;
  final int? courseId;

  const GetChaptersParams({this.page, this.courseId});

  @override
  List<Object?> get props => [page, courseId];
}

class GetChaptersUseCase implements UseCase<List<ChapterEntity>, GetChaptersParams> {
  final CourseRepository repository;

  const GetChaptersUseCase(this.repository);

  @override
  ResultFuture<List<ChapterEntity>> call([GetChaptersParams params = const GetChaptersParams()]) {
    return repository.getChapters(page: params.page, courseId: params.courseId);
  }
}
