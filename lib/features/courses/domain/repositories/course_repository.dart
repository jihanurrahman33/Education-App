import '../../../../core/utils/typedefs.dart';
import '../entities/course_entity.dart';

abstract class CourseRepository {
  ResultFuture<List<CourseEntity>> getCourses({
    String? category,
    String? searchQuery,
  });

  ResultFuture<List<CourseEntity>> getApprovedCourses({int? page});

  ResultFuture<CourseEntity> getCourseDetails(int courseId);

  ResultFuture<List<ChapterEntity>> getCourseCurriculum(int courseId);

  ResultFuture<void> enrollInCourse(int courseId);

  ResultFuture<List<CourseEntity>> getMyEnrolledCourses();

  ResultFuture<CourseEntity> createCourse({
    required String title,
    required String description,
    String? category,
    double? price,
  });

  ResultFuture<CourseEntity> togglePublish(int courseId);

  ResultFuture<List<ChapterEntity>> getChapters({int? page, int? courseId});

  ResultFuture<ChapterEntity> getChapterById(int chapterId);

  ResultFuture<ChapterEntity> createChapter({
    required int courseId,
    required String title,
    int order = 0,
  });

  ResultFuture<LessonEntity> createLesson({
    required int chapterId,
    required String title,
    String lessonType = 'video',
    String? textContent,
    String? videoFilePath,
    String? pdfFilePath,
    int durationMinutes = 0,
    int order = 0,
  });

  ResultFuture<LessonEntity> patchLesson({
    required int lessonId,
    String? title,
    String? lessonType,
    String? textContent,
    String? videoFilePath,
    String? pdfFilePath,
    int? durationMinutes,
    int? order,
  });
}
