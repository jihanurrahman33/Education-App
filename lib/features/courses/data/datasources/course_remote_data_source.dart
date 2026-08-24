import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/networking/api_client.dart';
import '../models/course_model.dart';

abstract class CourseRemoteDataSource {
  Future<List<CourseModel>> getCourses({
    String? category,
    String? searchQuery,
    int? page,
  });

  Future<List<CourseModel>> getApprovedCourses({int? page});

  Future<List<CourseModel>> getTeacherCourses({int? page});

  Future<CourseModel> getCourseDetails(int courseId);

  Future<List<ChapterModel>> getCourseCurriculum(int courseId);

  Future<void> enrollInCourse(int courseId);

  Future<List<CourseModel>> getMyEnrolledCourses();

  Future<CourseModel> createCourse({
    required String title,
    required String description,
    bool isPublished = false,
    String? category,
    double? price,
  });

  Future<CourseModel> updateCourse({
    required int id,
    required String title,
    String? description,
    bool? isPublished,
  });

  Future<CourseModel> patchCourse({
    required int id,
    String? title,
    String? description,
    bool? isPublished,
  });

  Future<void> deleteCourse(int id);

  Future<CourseModel> togglePublish(int courseId);

  Future<List<ChapterModel>> getChapters({int? page, int? courseId});

  Future<ChapterModel> getChapterById(int chapterId);

  Future<ChapterModel> createChapter({
    required int courseId,
    required String title,
    int order = 0,
  });

  Future<ChapterModel> updateChapter({
    required int id,
    required int courseId,
    required String title,
    int order = 0,
  });

  Future<ChapterModel> patchChapter({
    required int id,
    int? courseId,
    String? title,
    int? order,
  });

  Future<void> deleteChapter(int id);

  Future<List<LessonModel>> getLessons({int? chapterId, int? page});

  Future<LessonModel> getLessonById(int lessonId);

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

  Future<LessonModel> updateLesson({
    required int id,
    required int chapterId,
    required String title,
    String lessonType = 'video',
    String? textContent,
    int durationMinutes = 0,
    int order = 0,
  });

  Future<LessonModel> patchLesson({
    required int lessonId,
    int? chapterId,
    String? title,
    String? lessonType,
    String? textContent,
    String? videoFilePath,
    String? pdfFilePath,
    int? durationMinutes,
    int? order,
  });

  Future<void> deleteLesson(int lessonId);
}

class CourseRemoteDataSourceImpl implements CourseRemoteDataSource {
  final ApiClient apiClient;

  const CourseRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<CourseModel>> getCourses({
    String? category,
    String? searchQuery,
    int? page,
  }) async {
    final queryParams = <String, dynamic>{};
    if (category != null && category.isNotEmpty) {
      queryParams['category'] = category;
    }
    if (searchQuery != null && searchQuery.isNotEmpty) {
      queryParams['search'] = searchQuery;
    }
    if (page != null) {
      queryParams['page'] = page;
    }

    final response = await apiClient.get(
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

    final response = await apiClient.get(
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
  Future<List<CourseModel>> getTeacherCourses({int? page}) async {
    final queryParams = <String, dynamic>{};
    if (page != null) queryParams['page'] = page;

    final response = await apiClient.get(
      ApiEndpoints.teacherMyCourses,
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
    final response = await apiClient.get(ApiEndpoints.courseDetail(courseId));

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
    await apiClient.post(
      ApiEndpoints.enroll,
      data: {'course_id': courseId},
    );
  }

  @override
  Future<List<CourseModel>> getMyEnrolledCourses() async {
    final response = await apiClient.get(ApiEndpoints.myEnrollments);

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
    bool isPublished = false,
    String? category,
    double? price,
  }) async {
    final body = <String, dynamic>{
      'title': title,
      'description': description,
      'is_published': isPublished,
    };
    if (category != null) body['category'] = category;
    if (price != null) body['price'] = price;

    final response = await apiClient.post(
      ApiEndpoints.courses,
      data: body,
    );

    if (response is Map<String, dynamic>) {
      return CourseModel.fromJson(response);
    }

    throw Exception('Invalid create course response structure');
  }

  @override
  Future<CourseModel> updateCourse({
    required int id,
    required String title,
    String? description,
    bool? isPublished,
  }) async {
    final body = <String, dynamic>{
      'title': title,
    };
    if (description != null) body['description'] = description;
    if (isPublished != null) body['is_published'] = isPublished;

    final response = await apiClient.put(
      ApiEndpoints.courseDetail(id),
      data: body,
    );

    if (response is Map<String, dynamic>) {
      return CourseModel.fromJson(response);
    }

    throw Exception('Invalid update course response structure');
  }

  @override
  Future<CourseModel> patchCourse({
    required int id,
    String? title,
    String? description,
    bool? isPublished,
  }) async {
    final body = <String, dynamic>{};
    if (title != null) body['title'] = title;
    if (description != null) body['description'] = description;
    if (isPublished != null) body['is_published'] = isPublished;

    final response = await apiClient.patch(
      ApiEndpoints.courseDetail(id),
      data: body,
    );

    if (response is Map<String, dynamic>) {
      return CourseModel.fromJson(response);
    }

    throw Exception('Invalid patch course response structure');
  }

  @override
  Future<void> deleteCourse(int id) async {
    await apiClient.delete(ApiEndpoints.courseDetail(id));
  }

  @override
  Future<CourseModel> togglePublish(int courseId) async {
    final response = await apiClient.post(ApiEndpoints.togglePublish(courseId));

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

    final response = await apiClient.get(
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
    final response = await apiClient.get(ApiEndpoints.chapterDetail(chapterId));

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

    final response = await apiClient.post(
      ApiEndpoints.chapters,
      data: body,
    );

    if (response is Map<String, dynamic>) {
      return ChapterModel.fromJson(response);
    }

    throw Exception('Invalid create chapter response structure');
  }

  @override
  Future<ChapterModel> updateChapter({
    required int id,
    required int courseId,
    required String title,
    int order = 0,
  }) async {
    final body = {
      'course': courseId,
      'title': title,
      'order': order,
    };

    final response = await apiClient.put(
      ApiEndpoints.chapterDetail(id),
      data: body,
    );

    if (response is Map<String, dynamic>) {
      return ChapterModel.fromJson(response);
    }

    throw Exception('Invalid update chapter response structure');
  }

  @override
  Future<ChapterModel> patchChapter({
    required int id,
    int? courseId,
    String? title,
    int? order,
  }) async {
    final body = <String, dynamic>{};
    if (courseId != null) body['course'] = courseId;
    if (title != null) body['title'] = title;
    if (order != null) body['order'] = order;

    final response = await apiClient.patch(
      ApiEndpoints.chapterDetail(id),
      data: body,
    );

    if (response is Map<String, dynamic>) {
      return ChapterModel.fromJson(response);
    }

    throw Exception('Invalid patch chapter response structure');
  }

  @override
  Future<void> deleteChapter(int id) async {
    await apiClient.delete(ApiEndpoints.chapterDetail(id));
  }

  @override
  Future<List<LessonModel>> getLessons({int? chapterId, int? page}) async {
    final queryParams = <String, dynamic>{};
    if (page != null) queryParams['page'] = page;
    if (chapterId != null) queryParams['chapter'] = chapterId;

    final response = await apiClient.get(
      ApiEndpoints.lessons,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    if (response is List) {
      return response
          .whereType<Map<String, dynamic>>()
          .map((json) => LessonModel.fromJson(json))
          .toList();
    } else if (response is Map<String, dynamic> && response['results'] is List) {
      return (response['results'] as List)
          .whereType<Map<String, dynamic>>()
          .map((json) => LessonModel.fromJson(json))
          .toList();
    }

    return [];
  }

  @override
  Future<LessonModel> getLessonById(int lessonId) async {
    final response = await apiClient.get(ApiEndpoints.lessonDetail(lessonId));

    if (response is Map<String, dynamic>) {
      return LessonModel.fromJson(response);
    }

    throw Exception('Invalid lesson details response format');
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

    final response = await apiClient.post(
      ApiEndpoints.lessons,
      data: payload,
    );

    if (response is Map<String, dynamic>) {
      return LessonModel.fromJson(response);
    }

    throw Exception('Invalid create lesson response structure');
  }

  @override
  Future<LessonModel> updateLesson({
    required int id,
    required int chapterId,
    required String title,
    String lessonType = 'video',
    String? textContent,
    int durationMinutes = 0,
    int order = 0,
  }) async {
    final body = {
      'chapter': chapterId,
      'title': title,
      'lesson_type': lessonType,
      'text_content': textContent ?? '',
      'duration_minutes': durationMinutes,
      'order': order,
    };

    final response = await apiClient.put(
      ApiEndpoints.lessonDetail(id),
      data: body,
    );

    if (response is Map<String, dynamic>) {
      return LessonModel.fromJson(response);
    }

    throw Exception('Invalid update lesson response structure');
  }

  @override
  Future<LessonModel> patchLesson({
    required int lessonId,
    int? chapterId,
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
      if (chapterId != null) formMap['chapter'] = chapterId;
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
      if (chapterId != null) map['chapter'] = chapterId;
      if (title != null) map['title'] = title;
      if (lessonType != null) map['lesson_type'] = lessonType;
      if (textContent != null) map['text_content'] = textContent;
      if (durationMinutes != null) map['duration_minutes'] = durationMinutes;
      if (order != null) map['order'] = order;
      payload = map;
    }

    final response = await apiClient.patch(
      ApiEndpoints.lessonDetail(lessonId),
      data: payload,
    );

    if (response is Map<String, dynamic>) {
      return LessonModel.fromJson(response);
    }

    throw Exception('Invalid patch lesson response structure');
  }

  @override
  Future<void> deleteLesson(int lessonId) async {
    await apiClient.delete(ApiEndpoints.lessonDetail(lessonId));
  }
}
