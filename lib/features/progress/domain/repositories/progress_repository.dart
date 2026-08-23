import '../../../../core/utils/typedefs.dart';
import '../entities/progress_entity.dart';

abstract class ProgressRepository {
  ResultFuture<ProgressSummaryEntity> getProgressSummary();
  ResultFuture<CourseProgressEntity> getCourseProgress(int courseId);
  ResultVoid markLessonCompleted(int lessonId);
}
