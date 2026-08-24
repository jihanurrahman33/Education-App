import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/networking/api_client.dart';
import '../../../certificates/data/models/certificate_model.dart';
import '../models/progress_model.dart';

abstract class ProgressRemoteDataSource {
  Future<ProgressSummaryModel> getProgressSummary();

  Future<List<CourseProgressModel>> getMyProgress();

  Future<CourseProgressModel> getCourseProgress(int courseId);

  Future<void> enrollInCourse(int courseId);

  Future<List<CourseEnrollmentModel>> getEnrollments({int? page});

  Future<CompletedLessonModel> markLessonCompleted(int lessonId);

  Future<List<CompletedLessonModel>> getCompletedLessons({int? page});

  Future<CertificateModel> generateCertificate(int courseId);

  Future<List<CertificateModel>> getCertificates({int? page});

  Future<TeacherCourseProgressModel> getTeacherCourseStudentsProgress(int courseId);
}

class ProgressRemoteDataSourceImpl implements ProgressRemoteDataSource {
  final ApiClient apiClient;

  const ProgressRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<ProgressSummaryModel> getProgressSummary() async {
    final myProg = await getMyProgress();
    return ProgressSummaryModel.fromCourseList(myProg);
  }

  @override
  Future<List<CourseProgressModel>> getMyProgress() async {
    final response = await apiClient.get(ApiEndpoints.myProgress);

    if (response is List) {
      return response
          .whereType<Map<String, dynamic>>()
          .map((json) => CourseProgressModel.fromJson(json))
          .toList();
    } else if (response is Map<String, dynamic> && response['results'] is List) {
      return (response['results'] as List)
          .whereType<Map<String, dynamic>>()
          .map((json) => CourseProgressModel.fromJson(json))
          .toList();
    }

    return [];
  }

  @override
  Future<CourseProgressModel> getCourseProgress(int courseId) async {
    final response = await apiClient.get(ApiEndpoints.courseProgress(courseId));

    if (response is Map<String, dynamic>) {
      return CourseProgressModel.fromJson(response);
    }

    throw Exception('Invalid course progress response format');
  }

  @override
  Future<void> enrollInCourse(int courseId) async {
    await apiClient.post(
      ApiEndpoints.enroll,
      data: {'course_id': courseId},
    );
  }

  @override
  Future<List<CourseEnrollmentModel>> getEnrollments({int? page}) async {
    final queryParams = <String, dynamic>{};
    if (page != null) queryParams['page'] = page;

    final response = await apiClient.get(
      ApiEndpoints.enrollments,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    if (response is List) {
      return response
          .whereType<Map<String, dynamic>>()
          .map((json) => CourseEnrollmentModel.fromJson(json))
          .toList();
    } else if (response is Map<String, dynamic> && response['results'] is List) {
      return (response['results'] as List)
          .whereType<Map<String, dynamic>>()
          .map((json) => CourseEnrollmentModel.fromJson(json))
          .toList();
    }

    return [];
  }

  @override
  Future<CompletedLessonModel> markLessonCompleted(int lessonId) async {
    final response = await apiClient.post(
      ApiEndpoints.completeLesson,
      data: {'lesson': lessonId},
    );

    if (response is Map<String, dynamic>) {
      return CompletedLessonModel.fromJson(response);
    }

    throw Exception('Invalid mark lesson complete response format');
  }

  @override
  Future<List<CompletedLessonModel>> getCompletedLessons({int? page}) async {
    final queryParams = <String, dynamic>{};
    if (page != null) queryParams['page'] = page;

    final response = await apiClient.get(
      ApiEndpoints.completedLessons,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    if (response is List) {
      return response
          .whereType<Map<String, dynamic>>()
          .map((json) => CompletedLessonModel.fromJson(json))
          .toList();
    } else if (response is Map<String, dynamic> && response['results'] is List) {
      return (response['results'] as List)
          .whereType<Map<String, dynamic>>()
          .map((json) => CompletedLessonModel.fromJson(json))
          .toList();
    }

    return [];
  }

  @override
  Future<CertificateModel> generateCertificate(int courseId) async {
    final response = await apiClient.post(
      ApiEndpoints.generateCertificate(courseId),
      data: {'course_id': courseId},
    );

    if (response is Map<String, dynamic>) {
      return CertificateModel.fromJson(response);
    }

    throw Exception('Failed to generate certificate');
  }

  @override
  Future<List<CertificateModel>> getCertificates({int? page}) async {
    final queryParams = <String, dynamic>{};
    if (page != null) queryParams['page'] = page;

    final response = await apiClient.get(
      ApiEndpoints.certificates,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    if (response is List) {
      return response
          .whereType<Map<String, dynamic>>()
          .map((json) => CertificateModel.fromJson(json))
          .toList();
    } else if (response is Map<String, dynamic> && response['results'] is List) {
      return (response['results'] as List)
          .whereType<Map<String, dynamic>>()
          .map((json) => CertificateModel.fromJson(json))
          .toList();
    }

    return [];
  }

  @override
  Future<TeacherCourseProgressModel> getTeacherCourseStudentsProgress(int courseId) async {
    final response = await apiClient.get(
      ApiEndpoints.teacherCourseStudentsProgress(courseId),
    );

    if (response is Map<String, dynamic>) {
      return TeacherCourseProgressModel.fromJson(response);
    }

    throw Exception('Invalid teacher course students progress response format');
  }
}
