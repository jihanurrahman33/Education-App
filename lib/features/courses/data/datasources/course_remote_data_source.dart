import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/networking/api_client.dart';
import '../models/course_model.dart';

abstract class CourseRemoteDataSource {
  Future<List<CourseModel>> getCourses({
    String? category,
    String? searchQuery,
  });

  Future<List<CourseModel>> getApprovedCourses({int? page});

  Future<CourseModel> getCourseDetails(int courseId);

  Future<List<ChapterModel>> getCourseCurriculum(int courseId);

  Future<void> enrollInCourse(int courseId);

  Future<List<CourseModel>> getMyEnrolledCourses();

  Future<CourseModel> createCourse({
    required String title,
    required String description,
    String? category,
    double? price,
  });

  Future<CourseModel> togglePublish(int courseId);

  Future<List<ChapterModel>> getChapters({int? page, int? courseId});

  Future<ChapterModel> getChapterById(int chapterId);

  Future<ChapterModel> createChapter({
    required int courseId,
    required String title,
    int order = 0,
  });

  Future<LessonModel> createLesson({
    required int chapterId,
    required String title,
    String lessonType = 'video',
    String? textContent,
    String? videoFilePath,
    String? pdfFilePath,
    int durationMinutes = 0,
    int order = 0,
  });

  Future<LessonModel> patchLesson({
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

class CourseRemoteDataSourceImpl implements CourseRemoteDataSource {
  final ApiClient _apiClient;

  const CourseRemoteDataSourceImpl({required this._apiClient});

  @override
  Future<List<CourseModel>> getCourses({
    String? category,
    String? searchQuery,
  }) async {
    final queryParams = <String, dynamic>{};
    if (category != null && category.isNotEmpty) {
      queryParams['category'] = category;
    }
    if (searchQuery != null && searchQuery.isNotEmpty) {
      queryParams['search'] = searchQuery;
    }

    final response = await _apiClient.get(
      ApiEndpoints.courses,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    if (response is List) {
      return response
          .whereType<Map<String, dynamic>>()
          .map((json) => CourseModel.fromJson(json))
          .toList();
    } else if (response is Map<String, dynamic> && response['results'] is List) {
      return (response['results'] as List)
          .whereType<Map<String, dynamic>>()
          .map((json) => CourseModel.fromJson(json))
          .toList();
    }

    return [];
  }

  @override
  Future<List<CourseModel>> getApprovedCourses({int? page}) async {
    final queryParams = <String, dynamic>{};
    if (page != null) queryParams['page'] = page;

    final response = await _apiClient.get(
      ApiEndpoints.approvedCourses,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    if (response is List) {
      return response
          .whereType<Map<String, dynamic>>()
          .map((json) => CourseModel.fromJson(json))
          .toList();
    } else if (response is Map<String, dynamic> && response['results'] is List) {
      return (response['results'] as List)
          .whereType<Map<String, dynamic>>()
          .map((json) => CourseModel.fromJson(json))
          .toList();
    }

    return [];
  }

  @override
  Future<CourseModel> getCourseDetails(int courseId) async {
    final response = await _apiClient.get(ApiEndpoints.courseDetail(courseId));

    if (response is Map<String, dynamic>) {
      return CourseModel.fromJson(response);
    }

    throw Exception('Invalid course details response format');
  }

  @override
  Future<List<ChapterModel>> getCourseCurriculum(int courseId) async {
    return getChapters(courseId: courseId);
  }

  @override
  Future<void> enrollInCourse(int courseId) async {
    await _apiClient.post(
      ApiEndpoints.enroll,
      data: {'course_id': courseId},
    );
  }

  @override
  Future<List<CourseModel>> getMyEnrolledCourses() async {
    final response = await _apiClient.get(ApiEndpoints.myEnrollments);

    if (response is List) {
      return response
          .whereType<Map<String, dynamic>>()
          .map((json) => CourseModel.fromJson(json))
          .toList();
    } else if (response is Map<String, dynamic> && response['results'] is List) {
      return (response['results'] as List)
          .whereType<Map<String, dynamic>>()
          .map((json) => CourseModel.fromJson(json))
          .toList();
    }

    return [];
  }

  @override
  Future<CourseModel> createCourse({
    required String title,
    required String description,
    String? category,
    double? price,
  }) async {
    final body = <String, dynamic>{
      'title': title,
      'description': description,
    };
    if (category != null) body['category'] = category;
    if (price != null) body['price'] = price;

    final response = await _apiClient.post(
      ApiEndpoints.courses,
      data: body,
    );

    if (response is Map<String, dynamic>) {
      return CourseModel.fromJson(response);
    }

    throw Exception('Invalid create course response structure');
  }

  @override
  Future<CourseModel> togglePublish(int courseId) async {
    final response = await _apiClient.post(ApiEndpoints.togglePublish(courseId));

    if (response is Map<String, dynamic>) {
      return CourseModel.fromJson(response);
    }

    throw Exception('Invalid toggle publish response structure');
  }

  @override
  Future<List<ChapterModel>> getChapters({int? page, int? courseId}) async {
    final queryParams = <String, dynamic>{};
    if (page != null) queryParams['page'] = page;
    if (courseId != null) queryParams['course'] = courseId;

    final response = await _apiClient.get(
      ApiEndpoints.chapters,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    if (response is List) {
      return response
          .whereType<Map<String, dynamic>>()
          .map((json) => ChapterModel.fromJson(json))
          .toList();
    } else if (response is Map<String, dynamic> && response['results'] is List) {
      return (response['results'] as List)
          .whereType<Map<String, dynamic>>()
          .map((json) => ChapterModel.fromJson(json))
          .toList();
    }

    return [];
  }

  @override
  Future<ChapterModel> getChapterById(int chapterId) async {
    final response = await _apiClient.get(ApiEndpoints.chapterDetail(chapterId));

    if (response is Map<String, dynamic>) {
      return ChapterModel.fromJson(response);
    }

    throw Exception('Invalid chapter details response format');
  }

  @override
  Future<ChapterModel> createChapter({
    required int courseId,
    required String title,
    int order = 0,
  }) async {
    final body = {
      'course': courseId,
      'title': title,
      'order': order,
    };

    final response = await _apiClient.post(
      ApiEndpoints.chapters,
      data: body,
    );

    if (response is Map<String, dynamic>) {
      return ChapterModel.fromJson(response);
    }

    throw Exception('Invalid create chapter response structure');
  }

  @override
  Future<LessonModel> createLesson({
    required int chapterId,
    required String title,
    String lessonType = 'video',
    String? textContent,
    String? videoFilePath,
    String? pdfFilePath,
    int durationMinutes = 0,
    int order = 0,
  }) async {
    dynamic payload;
    if (videoFilePath != null || pdfFilePath != null) {
      final formMap = <String, dynamic>{
        'chapter': chapterId,
        'title': title,
        'lesson_type': lessonType,
        'text_content': textContent ?? '',
        'duration_minutes': durationMinutes,
        'order': order,
      };

      if (videoFilePath != null) {
        formMap['video_file'] = await MultipartFile.fromFile(videoFilePath);
      }
      if (pdfFilePath != null) {
        formMap['pdf_file'] = await MultipartFile.fromFile(pdfFilePath);
      }

      payload = FormData.fromMap(formMap);
    } else {
      payload = {
        'chapter': chapterId,
        'title': title,
        'lesson_type': lessonType,
        'text_content': textContent ?? '',
        'duration_minutes': durationMinutes,
        'order': order,
      };
    }

    final response = await _apiClient.post(
      ApiEndpoints.lessons,
      data: payload,
    );

    if (response is Map<String, dynamic>) {
      return LessonModel.fromJson(response);
    }

    throw Exception('Invalid create lesson response structure');
  }

  @override
  Future<LessonModel> patchLesson({
    required int lessonId,
    String? title,
    String? lessonType,
    String? textContent,
    String? videoFilePath,
    String? pdfFilePath,
    int? durationMinutes,
    int? order,
  }) async {
    dynamic payload;
    if (videoFilePath != null || pdfFilePath != null) {
      final formMap = <String, dynamic>{};
      if (title != null) formMap['title'] = title;
      if (lessonType != null) formMap['lesson_type'] = lessonType;
      if (textContent != null) formMap['text_content'] = textContent;
      if (durationMinutes != null) formMap['duration_minutes'] = durationMinutes;
      if (order != null) formMap['order'] = order;

      if (videoFilePath != null) {
        formMap['video_file'] = await MultipartFile.fromFile(videoFilePath);
      }
      if (pdfFilePath != null) {
        formMap['pdf_file'] = await MultipartFile.fromFile(pdfFilePath);
      }

      payload = FormData.fromMap(formMap);
    } else {
      final map = <String, dynamic>{};
      if (title != null) map['title'] = title;
      if (lessonType != null) map['lesson_type'] = lessonType;
      if (textContent != null) map['text_content'] = textContent;
      if (durationMinutes != null) map['duration_minutes'] = durationMinutes;
      if (order != null) map['order'] = order;
      payload = map;
    }

    final response = await _apiClient.patch(
      ApiEndpoints.lessonDetail(lessonId),
      data: payload,
    );

    if (response is Map<String, dynamic>) {
      return LessonModel.fromJson(response);
    }

    throw Exception('Invalid patch lesson response structure');
  }
}
