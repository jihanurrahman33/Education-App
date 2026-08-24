import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../../../certificates/domain/entities/certificate_entity.dart';
import '../repositories/progress_repository.dart';

class GetCertificatesUseCase implements UseCase<List<CertificateEntity>, int?> {
  final ProgressRepository repository;

  const GetCertificatesUseCase(this.repository);

  @override
  ResultFuture<List<CertificateEntity>> call([int? page]) {
    return repository.getCertificates(page: page);
  }
}
