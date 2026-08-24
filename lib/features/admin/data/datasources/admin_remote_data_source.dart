import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/networking/api_client.dart';
import '../models/admin_stats_model.dart';

abstract class AdminRemoteDataSource {
  Future<AdminStatsModel> getAdminStats();
  Future<void> approveTeacher(int teacherId);
  Future<void> approveCourse(int courseId);
  Future<void> rejectCourse(int courseId);
}

class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  final ApiClient apiClient;

  const AdminRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<AdminStatsModel> getAdminStats() async {
    final response = await apiClient.get(ApiEndpoints.adminStats);

    if (response is Map<String, dynamic>) {
      return AdminStatsModel.fromJson(response);
    }

    throw Exception('Invalid admin stats response format');
  }

  @override
  Future<void> approveTeacher(int teacherId) async {
    await apiClient.post(ApiEndpoints.adminApproveTeacher(teacherId));
  }

  @override
  Future<void> approveCourse(int courseId) async {
    await apiClient.post(ApiEndpoints.adminApproveCourse(courseId));
  }

  @override
  Future<void> rejectCourse(int courseId) async {
    await apiClient.post(ApiEndpoints.adminRejectCourse(courseId));
  }
}
