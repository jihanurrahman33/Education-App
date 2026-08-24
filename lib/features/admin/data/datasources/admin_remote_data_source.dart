import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/networking/api_client.dart';
import '../models/admin_course_model.dart';
import '../models/admin_stats_model.dart';
import '../models/admin_top_course_model.dart';
import '../models/admin_user_model.dart';

abstract class AdminRemoteDataSource {
  Future<AdminStatsModel> getAdminStats();
  Future<List<AdminTopCourseModel>> getTopCourses();
  Future<List<AdminCourseModel>> getPendingCourses({int? page});
  Future<List<AdminUserModel>> getPendingTeachers({int? page});
  Future<List<AdminUserModel>> getUsers({int? page, String? search});
  Future<AdminUserModel> getUserById(int userId);
  Future<AdminUserModel> createUser({
    required String username,
    required String email,
    required String role,
    String? firstName,
    String? lastName,
    String? phone,
    bool isActive = true,
    bool isApprovedTeacher = false,
  });
  Future<AdminUserModel> updateUser({
    required int id,
    required String username,
    required String email,
    required String role,
    String? firstName,
    String? lastName,
    String? phone,
    bool isActive = true,
    bool isApprovedTeacher = false,
  });
  Future<AdminUserModel> patchUser({
    required int id,
    String? username,
    String? email,
    String? role,
    String? firstName,
    String? lastName,
    String? phone,
    bool? isActive,
    bool? isApprovedTeacher,
  });
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
  Future<List<AdminTopCourseModel>> getTopCourses() async {
    final response = await apiClient.get(ApiEndpoints.adminTopCourses);

    if (response is List) {
      return response
          .whereType<Map<String, dynamic>>()
          .map((json) => AdminTopCourseModel.fromJson(json))
          .toList();
    }

    return [];
  }

  @override
  Future<List<AdminCourseModel>> getPendingCourses({int? page}) async {
    final queryParams = <String, dynamic>{};
    if (page != null) {
      queryParams['page'] = page;
    }

    final response = await apiClient.get(
      ApiEndpoints.adminPendingCourses,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    if (response is Map<String, dynamic> && response['results'] is List) {
      final results = response['results'] as List<dynamic>;
      return results
          .whereType<Map<String, dynamic>>()
          .map((json) => AdminCourseModel.fromJson(json))
          .toList();
    } else if (response is List) {
      return response
          .whereType<Map<String, dynamic>>()
          .map((json) => AdminCourseModel.fromJson(json))
          .toList();
    }

    return [];
  }

  @override
  Future<List<AdminUserModel>> getPendingTeachers({int? page}) async {
    final queryParams = <String, dynamic>{};
    if (page != null) {
      queryParams['page'] = page;
    }

    final response = await apiClient.get(
      ApiEndpoints.adminPendingTeachers,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    if (response is Map<String, dynamic> && response['results'] is List) {
      final results = response['results'] as List<dynamic>;
      return results
          .whereType<Map<String, dynamic>>()
          .map((json) => AdminUserModel.fromJson(json))
          .toList();
    } else if (response is List) {
      return response
          .whereType<Map<String, dynamic>>()
          .map((json) => AdminUserModel.fromJson(json))
          .toList();
    }

    return [];
  }

  @override
  Future<List<AdminUserModel>> getUsers({int? page, String? search}) async {
    final queryParams = <String, dynamic>{};
    if (page != null) {
      queryParams['page'] = page;
    }
    if (search != null && search.trim().isNotEmpty) {
      queryParams['search'] = search.trim();
    }

    final response = await apiClient.get(
      ApiEndpoints.adminUsers,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    if (response is Map<String, dynamic> && response['results'] is List) {
      final results = response['results'] as List<dynamic>;
      return results
          .whereType<Map<String, dynamic>>()
          .map((json) => AdminUserModel.fromJson(json))
          .toList();
    } else if (response is List) {
      return response
          .whereType<Map<String, dynamic>>()
          .map((json) => AdminUserModel.fromJson(json))
          .toList();
    }

    return [];
  }

  @override
  Future<AdminUserModel> getUserById(int userId) async {
    final response = await apiClient.get(ApiEndpoints.adminUserDetail(userId));

    if (response is Map<String, dynamic>) {
      return AdminUserModel.fromJson(response);
    }

    throw Exception('Invalid user detail response structure');
  }

  @override
  Future<AdminUserModel> createUser({
    required String username,
    required String email,
    required String role,
    String? firstName,
    String? lastName,
    String? phone,
    bool isActive = true,
    bool isApprovedTeacher = false,
  }) async {
    final body = <String, dynamic>{
      'username': username,
      'email': email,
      'role': role.toLowerCase(),
      'is_active': isActive,
      'is_approved_teacher': isApprovedTeacher,
    };

    if (firstName != null && firstName.isNotEmpty) body['first_name'] = firstName;
    if (lastName != null && lastName.isNotEmpty) body['last_name'] = lastName;
    if (phone != null && phone.isNotEmpty) body['phone'] = phone;

    final response = await apiClient.post(
      ApiEndpoints.adminUsers,
      data: body,
    );

    if (response is Map<String, dynamic>) {
      return AdminUserModel.fromJson(response);
    }

    throw Exception('Invalid create user response structure');
  }

  @override
  Future<AdminUserModel> updateUser({
    required int id,
    required String username,
    required String email,
    required String role,
    String? firstName,
    String? lastName,
    String? phone,
    bool isActive = true,
    bool isApprovedTeacher = false,
  }) async {
    final body = <String, dynamic>{
      'username': username,
      'email': email,
      'role': role.toLowerCase(),
      'is_active': isActive,
      'is_approved_teacher': isApprovedTeacher,
    };

    if (firstName != null && firstName.isNotEmpty) body['first_name'] = firstName;
    if (lastName != null && lastName.isNotEmpty) body['last_name'] = lastName;
    if (phone != null && phone.isNotEmpty) body['phone'] = phone;

    final response = await apiClient.put(
      ApiEndpoints.adminUserDetail(id),
      data: body,
    );

    if (response is Map<String, dynamic>) {
      return AdminUserModel.fromJson(response);
    }

    throw Exception('Invalid update user response structure');
  }

  @override
  Future<AdminUserModel> patchUser({
    required int id,
    String? username,
    String? email,
    String? role,
    String? firstName,
    String? lastName,
    String? phone,
    bool? isActive,
    bool? isApprovedTeacher,
  }) async {
    final body = <String, dynamic>{};

    if (username != null) body['username'] = username;
    if (email != null) body['email'] = email;
    if (role != null) body['role'] = role.toLowerCase();
    if (firstName != null) body['first_name'] = firstName;
    if (lastName != null) body['last_name'] = lastName;
    if (phone != null) body['phone'] = phone;
    if (isActive != null) body['is_active'] = isActive;
    if (isApprovedTeacher != null) body['is_approved_teacher'] = isApprovedTeacher;

    final response = await apiClient.patch(
      ApiEndpoints.adminUserDetail(id),
      data: body,
    );

    if (response is Map<String, dynamic>) {
      return AdminUserModel.fromJson(response);
    }

    throw Exception('Invalid patch user response structure');
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
