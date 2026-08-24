import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/course_entity.dart';
import '../repositories/course_repository.dart';

class UpdateLessonParams extends Equatable {
  final int id;
  final int chapterId;
  final String title;
  final String lessonType;
  final String? textContent;
  final int durationMinutes;
  final int order;

  const UpdateLessonParams({
    required this.id,
    required this.chapterId,
    required this.title,
    this.lessonType = 'video',
    this.textContent,
    this.durationMinutes = 0,
    this.order = 0,
  });

  @override
  List<Object?> get props => [
        id,
        chapterId,
        title,
        lessonType,
        textContent,
        durationMinutes,
        order,
      ];
}

class UpdateLessonUseCase implements UseCase<LessonEntity, UpdateLessonParams> {
  final CourseRepository repository;

  const UpdateLessonUseCase(this.repository);

  @override
  ResultFuture<LessonEntity> call(UpdateLessonParams params) {
    return repository.updateLesson(
      id: params.id,
      chapterId: params.chapterId,
      title: params.title,
      lessonType: params.lessonType,
      textContent: params.textContent,
      durationMinutes: params.durationMinutes,
      order: params.order,
    );
  }
}
