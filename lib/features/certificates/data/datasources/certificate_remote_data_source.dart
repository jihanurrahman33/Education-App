import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/networking/api_client.dart';
import '../models/certificate_model.dart';

abstract class CertificateRemoteDataSource {
  Future<List<CertificateModel>> getMyCertificates();
  Future<CertificateModel> generateCertificate(int courseId);
}

class CertificateRemoteDataSourceImpl implements CertificateRemoteDataSource {
  final ApiClient apiClient;

  const CertificateRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<CertificateModel>> getMyCertificates() async {
    final response = await apiClient.get(ApiEndpoints.certificates);

    if (response is List) {
      return response
          .whereType<Map<String, dynamic>>()
          .map((c) => CertificateModel.fromJson(c))
          .toList();
    } else if (response is Map<String, dynamic> && response['results'] is List) {
      return (response['results'] as List)
          .whereType<Map<String, dynamic>>()
          .map((c) => CertificateModel.fromJson(c))
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
}
