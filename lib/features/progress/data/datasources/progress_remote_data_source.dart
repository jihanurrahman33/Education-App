import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/networking/api_client.dart';
import '../models/progress_model.dart';

abstract class ProgressRemoteDataSource {
  Future<ProgressSummaryModel> getProgressSummary();
  Future<CourseProgressModel> getCourseProgress(int courseId);
  Future<void> markLessonCompleted(int lessonId);
}

class ProgressRemoteDataSourceImpl implements ProgressRemoteDataSource {
  final ApiClient _apiClient;

  const ProgressRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<ProgressSummaryModel> getProgressSummary() async {
    final response = await _apiClient.get(ApiEndpoints.progressSummary);

    if (response is Map<String, dynamic>) {
      return ProgressSummaryModel.fromJson(response);
    }

    throw Exception('Invalid progress summary response');
  }

  @override
  Future<CourseProgressModel> getCourseProgress(int courseId) async {
    final response = await _apiClient.get(
      ApiEndpoints.progress,
      queryParameters: {'course_id': courseId},
    );

    if (response is Map<String, dynamic>) {
      return CourseProgressModel.fromJson(response);
    }

    throw Exception('Invalid course progress response');
  }

  @override
  Future<void> markLessonCompleted(int lessonId) async {
    await _apiClient.post(
      ApiEndpoints.completeLesson,
      data: {'lesson_id': lessonId},
    );
  }
}
