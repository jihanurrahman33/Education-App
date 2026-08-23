import '../../../../core/utils/typedefs.dart';
import '../entities/certificate_entity.dart';

abstract class CertificateRepository {
  ResultFuture<List<CertificateEntity>> getMyCertificates();
  ResultFuture<CertificateEntity> generateCertificate(int courseId);
}
