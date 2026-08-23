import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/certificate_entity.dart';
import '../repositories/certificate_repository.dart';

class GenerateCertificateParams extends Equatable {
  final int courseId;

  const GenerateCertificateParams({required this.courseId});

  @override
  List<Object?> get props => [courseId];
}

class GenerateCertificateUseCase
    implements UseCase<CertificateEntity, GenerateCertificateParams> {
  final CertificateRepository _repository;

  const GenerateCertificateUseCase(this._repository);

  @override
  ResultFuture<CertificateEntity> call(GenerateCertificateParams params) {
    return _repository.generateCertificate(params.courseId);
  }
}
