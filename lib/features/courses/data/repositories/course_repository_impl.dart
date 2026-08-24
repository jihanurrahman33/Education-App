import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/course_entity.dart';
import '../../domain/repositories/course_repository.dart';
import '../datasources/course_remote_data_source.dart';

class CourseRepositoryImpl implements CourseRepository {
  final CourseRemoteDataSource remoteDataSource;

  const CourseRepositoryImpl({required this.remoteDataSource});

  @override
  ResultFuture<List<CourseEntity>> getCourses({
    String? category,
    String? searchQuery,
    int? page,
  }) async {
    try {
      final courses = await remoteDataSource.getCourses(
        category: category,
        searchQuery: searchQuery,
        page: page,
      );
      return Right(courses);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<List<CourseEntity>> getApprovedCourses({int? page}) async {
    try {
      final courses = await remoteDataSource.getApprovedCourses(page: page);
      return Right(courses);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<CourseEntity> getCourseDetails(int courseId) async {
    try {
      final course = await remoteDataSource.getCourseDetails(courseId);
      return Right(course);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<List<ChapterEntity>> getCourseCurriculum(int courseId) async {
    try {
      final chapters = await remoteDataSource.getCourseCurriculum(courseId);
      return Right(chapters);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  ResultVoid enrollInCourse(int courseId) async {
    try {
      await remoteDataSource.enrollInCourse(courseId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<List<CourseEntity>> getMyEnrolledCourses() async {
    try {
      final courses = await remoteDataSource.getMyEnrolledCourses();
      return Right(courses);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<CourseEntity> createCourse({
    required String title,
    required String description,
    bool isPublished = false,
    String? category,
    double? price,
  }) async {
    try {
      final course = await remoteDataSource.createCourse(
        title: title,
        description: description,
        isPublished: isPublished,
        category: category,
        price: price,
      );
      return Right(course);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<CourseEntity> togglePublish(int courseId) async {
    try {
      final course = await remoteDataSource.togglePublish(courseId);
      return Right(course);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<List<ChapterEntity>> getChapters({int? page, int? courseId}) async {
    try {
      final chapters = await remoteDataSource.getChapters(page: page, courseId: courseId);
      return Right(chapters);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<ChapterEntity> getChapterById(int chapterId) async {
    try {
      final chapter = await remoteDataSource.getChapterById(chapterId);
      return Right(chapter);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<ChapterEntity> createChapter({
    required int courseId,
    required String title,
    int order = 0,
  }) async {
    try {
      final chapter = await remoteDataSource.createChapter(
        courseId: courseId,
        title: title,
        order: order,
      );
      return Right(chapter);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<ChapterEntity> updateChapter({
    required int id,
    required int courseId,
    required String title,
    int order = 0,
  }) async {
    try {
      final chapter = await remoteDataSource.updateChapter(
        id: id,
        courseId: courseId,
        title: title,
        order: order,
      );
      return Right(chapter);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<ChapterEntity> patchChapter({
    required int id,
    int? courseId,
    String? title,
    int? order,
  }) async {
    try {
      final chapter = await remoteDataSource.patchChapter(
        id: id,
        courseId: courseId,
        title: title,
        order: order,
      );
      return Right(chapter);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  ResultVoid deleteChapter(int id) async {
    try {
      await remoteDataSource.deleteChapter(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<LessonEntity> createLesson({
    required int chapterId,
    required String title,
    String lessonType = 'video',
    String? textContent,
    String? videoFilePath,
    String? pdfFilePath,
    int durationMinutes = 0,
    int order = 0,
  }) async {
    try {
      final lesson = await remoteDataSource.createLesson(
        chapterId: chapterId,
        title: title,
        lessonType: lessonType,
        textContent: textContent,
        videoFilePath: videoFilePath,
        pdfFilePath: pdfFilePath,
        durationMinutes: durationMinutes,
        order: order,
      );
      return Right(lesson);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  ResultFuture<LessonEntity> patchLesson({
    required int lessonId,
    String? title,
    String? lessonType,
    String? textContent,
    String? videoFilePath,
    String? pdfFilePath,
    int? durationMinutes,
    int? order,
  }) async {
    try {
      final lesson = await remoteDataSource.patchLesson(
        lessonId: lessonId,
        title: title,
        lessonType: lessonType,
        textContent: textContent,
        videoFilePath: videoFilePath,
        pdfFilePath: pdfFilePath,
        durationMinutes: durationMinutes,
        order: order,
      );
      return Right(lesson);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on UnauthorizedException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
