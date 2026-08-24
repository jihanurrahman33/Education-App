import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/generate_certificate_usecase.dart';
import '../../domain/usecases/get_certificates_usecase.dart';
import 'certificate_event.dart';
import 'certificate_state.dart';

class CertificateBloc extends Bloc<CertificateEvent, CertificateState> {
  final GetCertificatesUseCase getCertificatesUseCase;
  final GenerateCertificateUseCase generateCertificateUseCase;

  CertificateBloc({
    required this.getCertificatesUseCase,
    required this.generateCertificateUseCase,
  }) : super(const CertificateState()) {
    on<LoadCertificatesEvent>(_onLoadCertificates);
    on<ClaimCertificateEvent>(_onClaimCertificate);
  }

  Future<void> _onLoadCertificates(
    LoadCertificatesEvent event,
    Emitter<CertificateState> emit,
  ) async {
    emit(state.copyWith(status: CertificateStatus.loading, clearMessages: true));

    final result = await getCertificatesUseCase(page: event.page);

    result.fold(
      (failure) => emit(state.copyWith(
        status: CertificateStatus.failure,
        errorMessage: failure.message,
      )),
      (certs) => emit(state.copyWith(
        status: CertificateStatus.success,
        certificates: certs,
      )),
    );
  }

  Future<void> _onClaimCertificate(
    ClaimCertificateEvent event,
    Emitter<CertificateState> emit,
  ) async {
    emit(state.copyWith(status: CertificateStatus.loading, clearMessages: true));

    final result = await generateCertificateUseCase(event.courseId);

    result.fold(
      (failure) => emit(state.copyWith(
        status: CertificateStatus.failure,
        errorMessage: failure.message,
      )),
      (cert) {
        final updated = [cert, ...state.certificates];
        emit(state.copyWith(
          status: CertificateStatus.success,
          certificates: updated,
          latestGeneratedCertificate: cert,
          successMessage: 'Certificate generated for "${cert.courseTitle}"!',
        ));
      },
    );
  }
}
