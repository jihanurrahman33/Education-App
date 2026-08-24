import '../../../../core/utils/typedefs.dart';
import '../../../certificates/domain/entities/certificate_entity.dart';
import '../entities/progress_entity.dart';

abstract class ProgressRepository {
  ResultFuture<ProgressSummaryEntity> getProgressSummary();

  ResultFuture<List<CourseProgressEntity>> getMyProgress();

  ResultFuture<CourseProgressEntity> getCourseProgress(int courseId);

  ResultVoid enrollInCourse(int courseId);

  ResultFuture<List<CourseEnrollmentEntity>> getEnrollments({int? page});

  ResultFuture<CompletedLessonEntity> markLessonCompleted(int lessonId);

  ResultFuture<List<CompletedLessonEntity>> getCompletedLessons({int? page});

  ResultFuture<CertificateEntity> generateCertificate(int courseId);

  ResultFuture<List<CertificateEntity>> getCertificates({int? page});

  ResultFuture<TeacherCourseProgressEntity> getTeacherCourseStudentsProgress(int courseId);
}
