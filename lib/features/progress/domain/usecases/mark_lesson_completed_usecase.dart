import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../repositories/progress_repository.dart';

class MarkLessonCompletedParams extends Equatable {
  final int lessonId;

  const MarkLessonCompletedParams({required this.lessonId});

  @override
  List<Object?> get props => [lessonId];
}

class MarkLessonCompletedUseCase implements UseCase<void, MarkLessonCompletedParams> {
  final ProgressRepository _repository;

  const MarkLessonCompletedUseCase(this._repository);

  @override
  ResultVoid call(MarkLessonCompletedParams params) {
    return _repository.markLessonCompleted(params.lessonId);
  }
}
