import '../../../../core/utils/typedefs.dart';
import '../entities/course_entity.dart';

abstract class CourseRepository {
  ResultFuture<List<CourseEntity>> getCourses({
    String? category,
    String? searchQuery,
  });

  ResultFuture<CourseEntity> getCourseDetails(int courseId);

  ResultFuture<List<ChapterEntity>> getCourseCurriculum(int courseId);

  ResultFuture<void> enrollInCourse(int courseId);

  ResultFuture<List<CourseEntity>> getMyEnrolledCourses();
}
