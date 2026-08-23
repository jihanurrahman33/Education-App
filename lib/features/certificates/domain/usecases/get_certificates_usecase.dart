import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/certificate_entity.dart';
import '../repositories/certificate_repository.dart';

class GetCertificatesUseCase implements UseCase<List<CertificateEntity>, NoParams> {
  final CertificateRepository _repository;

  const GetCertificatesUseCase(this._repository);

  @override
  ResultFuture<List<CertificateEntity>> call(NoParams params) {
    return _repository.getMyCertificates();
  }
}
