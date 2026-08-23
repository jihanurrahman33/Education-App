import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/networking/api_client.dart';
import '../models/course_model.dart';

abstract class CourseRemoteDataSource {
  Future<List<CourseModel>> getCourses({
    String? category,
    String? searchQuery,
  });

  Future<CourseModel> getCourseDetails(int courseId);

  Future<List<ChapterModel>> getCourseCurriculum(int courseId);

  Future<void> enrollInCourse(int courseId);

  Future<List<CourseModel>> getMyEnrolledCourses();
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
      queryParameters: queryParams,
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
    final response = await _apiClient.get('${ApiEndpoints.courses}$courseId/');

    if (response is Map<String, dynamic>) {
      return CourseModel.fromJson(response);
    }

    throw Exception('Invalid course details response format');
  }

  @override
  Future<List<ChapterModel>> getCourseCurriculum(int courseId) async {
    final response = await _apiClient.get(
      ApiEndpoints.chapters,
      queryParameters: {'course': courseId},
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
}
