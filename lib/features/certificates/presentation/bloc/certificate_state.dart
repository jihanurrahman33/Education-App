import 'package:equatable/equatable.dart';
import '../../domain/entities/certificate_entity.dart';

enum CertificateStatus { initial, loading, success, failure }

class CertificateState extends Equatable {
  final CertificateStatus status;
  final List<CertificateEntity> certificates;
  final CertificateEntity? latestGeneratedCertificate;
  final String? errorMessage;
  final String? successMessage;

  const CertificateState({
    this.status = CertificateStatus.initial,
    this.certificates = const [],
    this.latestGeneratedCertificate,
    this.errorMessage,
    this.successMessage,
  });

  CertificateState copyWith({
    CertificateStatus? status,
    List<CertificateEntity>? certificates,
    CertificateEntity? latestGeneratedCertificate,
    String? errorMessage,
    String? successMessage,
    bool clearMessages = false,
  }) {
    return CertificateState(
      status: status ?? this.status,
      certificates: certificates ?? this.certificates,
      latestGeneratedCertificate:
          latestGeneratedCertificate ?? this.latestGeneratedCertificate,
      errorMessage: clearMessages ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearMessages ? null : (successMessage ?? this.successMessage),
    );
  }

  @override
  List<Object?> get props => [
        status,
        certificates,
        latestGeneratedCertificate,
        errorMessage,
        successMessage,
      ];
}
