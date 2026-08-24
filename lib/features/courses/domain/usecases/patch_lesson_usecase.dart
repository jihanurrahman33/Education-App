import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/course_entity.dart';
import '../repositories/course_repository.dart';

class PatchLessonParams extends Equatable {
  final int lessonId;
  final int? chapterId;
  final String? title;
  final String? lessonType;
  final String? textContent;
  final String? videoFilePath;
  final String? pdfFilePath;
  final int? durationMinutes;
  final int? order;

  const PatchLessonParams({
    required this.lessonId,
    this.chapterId,
    this.title,
    this.lessonType,
    this.textContent,
    this.videoFilePath,
    this.pdfFilePath,
    this.durationMinutes,
    this.order,
  });

  @override
  List<Object?> get props => [
        lessonId,
        chapterId,
        title,
        lessonType,
        textContent,
        videoFilePath,
        pdfFilePath,
        durationMinutes,
        order,
      ];
}

class PatchLessonUseCase implements UseCase<LessonEntity, PatchLessonParams> {
  final CourseRepository repository;

  const PatchLessonUseCase(this.repository);

  @override
  ResultFuture<LessonEntity> call(PatchLessonParams params) {
    return repository.patchLesson(
      lessonId: params.lessonId,
      chapterId: params.chapterId,
      title: params.title,
      lessonType: params.lessonType,
      textContent: params.textContent,
      videoFilePath: params.videoFilePath,
      pdfFilePath: params.pdfFilePath,
      durationMinutes: params.durationMinutes,
      order: params.order,
    );
  }
}
