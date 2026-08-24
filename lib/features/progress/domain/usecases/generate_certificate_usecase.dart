import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../../../certificates/domain/entities/certificate_entity.dart';
import '../repositories/progress_repository.dart';

class GenerateCertificateUseCase implements UseCase<CertificateEntity, int> {
  final ProgressRepository repository;

  const GenerateCertificateUseCase(this.repository);

  @override
  ResultFuture<CertificateEntity> call(int courseId) {
    return repository.generateCertificate(courseId);
  }
}
