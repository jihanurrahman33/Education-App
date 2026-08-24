import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/course_entity.dart';
import '../repositories/course_repository.dart';

class CreateLessonParams extends Equatable {
  final int chapterId;
  final String title;
  final String lessonType;
  final String? textContent;
  final String? videoFilePath;
  final String? pdfFilePath;
  final int durationMinutes;
  final int order;

  const CreateLessonParams({
    required this.chapterId,
    required this.title,
    this.lessonType = 'video',
    this.textContent,
    this.videoFilePath,
    this.pdfFilePath,
    this.durationMinutes = 0,
    this.order = 0,
  });

  @override
  List<Object?> get props => [
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

class CreateLessonUseCase implements UseCase<LessonEntity, CreateLessonParams> {
  final CourseRepository repository;

  const CreateLessonUseCase(this.repository);

  @override
  ResultFuture<LessonEntity> call(CreateLessonParams params) {
    return repository.createLesson(
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
